#pragma once
#include "pch.h"
#include <windows.ui.xaml.hosting.desktopwindowxamlsource.h>
#include <winrt/Magpie.App.h>


class XamlApp {
public:
	XamlApp() = default;

	XamlApp(const XamlApp&) = delete;
	XamlApp(XamlApp&&) = delete;

	static XamlApp& Get() {
		static XamlApp instance;
		return instance;
	}

	bool Initialize(HINSTANCE hInstance, const wchar_t* className, const wchar_t* title);

	int Run();

private:
	ATOM _RegisterWndClass(HINSTANCE hInstance, const wchar_t* className);

	void _OnResize();

	static LRESULT _WndProcStatic(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
		return Get()._WndProc(hWnd, msg, wParam, lParam);
	}
	LRESULT _WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

	winrt::Magpie::App::App _uwpApp{ nullptr };
	winrt::Magpie::App::MainPage _mainPage{ nullptr };
	HWND _hwndXamlHost = NULL;
	HWND _hwndXamlIsland = NULL;

	winrt::Windows::UI::Xaml::Hosting::DesktopWindowXamlSource _xamlSource{ nullptr };
	winrt::com_ptr<IDesktopWindowXamlSourceNative2> _xamlSourceNative2;
};