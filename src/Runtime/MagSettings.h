#pragma once

#include "MagSettings.g.h"

namespace winrt::Magpie::Runtime::implementation {

struct MagSettings : MagSettingsT<MagSettings> {
    MagSettings() = default;

    CaptureMode CaptureMode() const noexcept {
        return _captureMode;
    }

    void CaptureMode(Magpie::Runtime::CaptureMode value) noexcept {
        _captureMode = value;
    }

    bool IsBreakpointMode() const noexcept {
        return _isBreakpointMode;
    }

    void IsBreakpointMode(bool value) noexcept {
        _isBreakpointMode = value;
    }

    bool IsDisableEffectCache() const noexcept {
        return _isDisableEffectCache;
    }

    void IsDisableEffectCache(bool value) noexcept {
        _isDisableEffectCache = value;
    }

    bool IsSaveEffectSources() const noexcept {
        return _isSaveEffectSources;
    }

    void IsSaveEffectSources(bool value) noexcept {
        _isSaveEffectSources = value;
    }

    bool IsWarningsAreErrors() const noexcept {
        return _isWarningsAreErrors;
    }

    void IsWarningsAreErrors(bool value) noexcept {
        _isWarningsAreErrors = value;
    }

private:
    Magpie::Runtime::CaptureMode _captureMode = Magpie::Runtime::CaptureMode::GraphicsCapture;

    bool _isBreakpointMode = false;
    bool _isDisableEffectCache = false;
    bool _isSaveEffectSources = false;
    bool _isWarningsAreErrors = false;
};

}

namespace winrt::Magpie::Runtime::factory_implementation {

struct MagSettings : MagSettingsT<MagSettings, implementation::MagSettings> {
};

}