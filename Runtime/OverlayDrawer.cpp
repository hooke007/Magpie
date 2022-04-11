#include "pch.h"
#include "OverlayDrawer.h"
#include "App.h"
#include "DeviceResources.h"
#include <imgui.h>
#include <imgui_internal.h>
#include "imgui_impl_magpie.h"
#include "imgui_impl_dx11.h"
#include "Renderer.h"
#include "GPUTimer.h"
#include "CursorManager.h"
#include "Logger.h"
#include "Config.h"


OverlayDrawer::~OverlayDrawer() {
	if (_handlerID != 0) {
		App::Get().UnregisterWndProcHandler(_handlerID);
	}

	ImGui_ImplDX11_Shutdown();
	ImGui_ImplMagpie_Shutdown();
	ImGui::DestroyContext();
}

float GetDpiScale() {
	return GetDpiForWindow(App::Get().GetHwndHost()) / 96.0f;
}

static std::optional<LRESULT> WndProcHandler(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
	ImGui_ImplMagpie_WndProcHandler(hWnd, msg, wParam, lParam);
	return std::nullopt;
}

bool OverlayDrawer::Initialize(ID3D11Texture2D* renderTarget) {
	auto& dr = App::Get().GetDeviceResources();

	IMGUI_CHECKVERSION();
	ImGui::CreateContext();

	ImGuiIO& io = ImGui::GetIO();
	io.ConfigFlags |= ImGuiConfigFlags_NavNoCaptureKeyboard | ImGuiConfigFlags_NoMouseCursorChange;
	
	float dpiScale = GetDpiScale();

	ImGui::StyleColorsDark();
	ImGuiStyle& style = ImGui::GetStyle();
	style.WindowRounding = 6;
	style.FrameBorderSize = 1;
	style.WindowMinSize = ImVec2(10, 10);
	style.ScaleAllSizes(dpiScale);

	std::vector<BYTE> fontData;
	if (!Utils::ReadFile(L".\\assets\\NotoSansSC-Regular.otf", fontData)) {
		Logger::Get().Error("读取字体文件失败");
		return false;
	}

	ImFontConfig config;
	config.FontDataOwnedByAtlas = false;
	_fontSmall = io.Fonts->AddFontFromMemoryTTF(fontData.data(), (int)fontData.size(), std::floor(18 * dpiScale), &config, io.Fonts->GetGlyphRangesDefault());

	ImVector<ImWchar> fpsRanges;
	ImFontGlyphRangesBuilder builder;
	builder.AddText("0123456789 FPS");
	builder.BuildRanges(&fpsRanges);
	_fontLarge = io.Fonts->AddFontFromMemoryTTF(fontData.data(), (int)fontData.size(), std::floor(36 * dpiScale), &config, fpsRanges.Data);

	io.Fonts->Build();

	ImGui_ImplMagpie_Init();
	ImGui_ImplDX11_Init(dr.GetD3DDevice(), dr.GetD3DDC());

	dr.GetRenderTargetView(renderTarget, &_rtv);

	_handlerID = App::Get().RegisterWndProcHandler(WndProcHandler);

	return true;
}

void OverlayDrawer::Draw() {
	bool isShowFPS = App::Get().GetConfig().IsShowFPS();

	if (!_isUIVisiable && !isShowFPS) {
		return;
	}

	ImGuiIO& io = ImGui::GetIO();
	CursorManager& cm = App::Get().GetCursorManager();

	bool originWantCaptureMouse = io.WantCaptureMouse;

	ImGui_ImplMagpie_NewFrame();
	ImGui_ImplDX11_NewFrame();
	ImGui::NewFrame();

	if (io.WantCaptureMouse) {
		if (!originWantCaptureMouse) {
			cm.OnCursorHoverOverlay();
		}
	} else {
		if (originWantCaptureMouse) {
			cm.OnCursorLeaveOverlay();
		}
	}

	// 将所有 ImGUI 窗口限制在视口内
	SIZE outputSize = Utils::GetSizeOfRect(App::Get().GetRenderer().GetOutputRect());
	for (ImGuiWindow* window : ImGui::GetCurrentContext()->Windows) {
		if (outputSize.cx > window->Size.x) {
			window->Pos.x = std::clamp(window->Pos.x, 0.0f, outputSize.cx - window->Size.x);
		} else {
			window->Pos.x = 0;
		}

		if (outputSize.cy > window->Size.y) {
			window->Pos.y = std::clamp(window->Pos.y, 0.0f, outputSize.cy - window->Size.y);
		} else {
			window->Pos.y = 0;
		}
	}

	ImGui::PushFont(_fontSmall);

	if (isShowFPS) {
		_DrawFPS();
	}
	
	if (_isUIVisiable) {
		_DrawUI();
	}

	ImGui::PopFont();

	ImGui::Render();

	const RECT& outputRect = App::Get().GetRenderer().GetOutputRect();
	ImGui::GetDrawData()->DisplayPos = ImVec2(float(-outputRect.left), float(-outputRect.top));
	
	auto d3dDC = App::Get().GetDeviceResources().GetD3DDC();
	d3dDC->OMSetRenderTargets(1, &_rtv, NULL);
	
	ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
}

void OverlayDrawer::SetUIVisibility(bool value) {
	if (_isUIVisiable == value) {
		return;
	}
	_isUIVisiable = value;

	if (!value && !App::Get().GetConfig().IsShowFPS()) {
		ImGui_ImplMagpie_ClearStates();
	}
}

void OverlayDrawer::_DrawFPS() {
	static float fontSize = 0.5f;
	static float opacity = 0.5f;
	static ImVec4 fpsColor(1, 1, 1, 1);

	const ImGuiViewport* main_viewport = ImGui::GetMainViewport();
	ImGui::SetNextWindowPos(ImVec2(20, 20), ImGuiCond_FirstUseEver);
	ImGui::SetNextWindowBgAlpha(opacity);

	ImGui::PushStyleVar(ImGuiStyleVar_WindowBorderSize, 0.0f);
	ImGui::PushStyleVar(ImGuiStyleVar_WindowPadding, ImVec2(2 + 6 * fontSize, 2));
	if (!ImGui::Begin("FPS", nullptr, ImGuiWindowFlags_NoNav | ImGuiWindowFlags_AlwaysAutoResize | ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_NoFocusOnAppearing | ImGuiWindowFlags_NoNav)) {
		// Early out if the window is collapsed, as an optimization.
		ImGui::End();
		return;
	}

	ImFont* font = nullptr;
	if (fontSize <= 1.0f / 3.0f) {
		_fontSmall->Scale = fontSize * 1.5f + 0.5f;
		font = _fontSmall;
	} else {
		_fontLarge->Scale = fontSize * 0.75f + 0.25f;
		font = _fontLarge;
	}

	ImGui::PushFont(font);
	ImGui::TextColored(fpsColor, fmt::format("{} FPS", App::Get().GetRenderer().GetGPUTimer().GetFramesPerSecond()).c_str());
	ImGui::PopFont();
	font->Scale = 1.0f;

	if (font == _fontSmall) {
		// 还原字体
		ImGui::PushFont(_fontSmall);
		ImGui::PopFont();
	}

	ImGui::PopStyleVar();

	if (ImGui::BeginPopupContextWindow()) {
		ImGui::PushItemWidth(200);
		ImGui::SliderFloat("Opacity", &opacity, 0.0f, 1.0f);
		ImGui::SliderFloat("Size", &fontSize, 0.0f, 1.0f);
		ImGui::ColorEdit4("Text Color", &fpsColor.x, ImGuiColorEditFlags_AlphaBar | ImGuiColorEditFlags_DisplayRGB);
		ImGui::PopItemWidth();
		ImGui::EndPopup();
	}

	ImGui::End();
	ImGui::PopStyleVar();
}

void OverlayDrawer::_DrawUI() {
	ImGui::ShowDemoWindow();
}
