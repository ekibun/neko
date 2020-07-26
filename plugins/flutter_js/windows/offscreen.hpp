/*
 * @Description: 
 * @Author: ekibun
 * @Date: 2020-07-26 13:05:44
 * @LastEditors: ekibun
 * @LastEditTime: 2020-07-26 14:30:15
 */ 
#include<windows.h>
#include "webview/WebView2.h"

const auto OFFSCREEN_CLASS = TEXT("OFFSCREENWINDOW");

namespace {
  bool __classRegistered = false;
  ATOM MyRegisterClass(HINSTANCE hInstance)
  {
    if(__classRegistered) return NULL;
    __classRegistered = true;
    WNDCLASSEX wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);

    wcex.style   = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = DefWindowProc;
    wcex.cbClsExtra  = 0;
    wcex.cbWndExtra  = 0;
    wcex.hInstance  = hInstance;
    wcex.hIcon   = NULL;
    wcex.hCursor  = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName = NULL;//MAKEINTRESOURCE(IDC_XEYE);
    wcex.lpszClassName = OFFSCREEN_CLASS;
    wcex.hIconSm  = NULL;

    return RegisterClassEx(&wcex);
  }
}


HWND createOffscreenWindow() {
  MyRegisterClass(GetModuleHandle(NULL));
  return CreateWindowEx(WS_EX_NOACTIVATE, OFFSCREEN_CLASS, TEXT("offscreen"), 
    WS_POPUP, 0, 0, 1, 1, NULL, NULL, 0, NULL);
}

wil::com_ptr<ICoreWebView2Controller> webviewController;
ICoreWebView2* webviewWindow;

void testWebView() {
    HWND hWnd = createOffscreenWindow();
    CreateCoreWebView2EnvironmentWithOptions(nullptr, nullptr, nullptr, 
      Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler>(
        [hWnd](HRESULT result, ICoreWebView2Environment* env) -> HRESULT {
            // Create a CoreWebView2Controller and get the associated CoreWebView2 whose parent is the main window hWnd
            std::cout << "hello:" << hWnd << std::endl;
            env->CreateCoreWebView2Controller(hWnd, Microsoft::WRL::Callback<ICoreWebView2CreateCoreWebView2ControllerCompletedHandler>(
                [hWnd](HRESULT result, ICoreWebView2Controller* controller) -> HRESULT {
                  std::cout << "hello webview" << std::endl;
                if (controller != nullptr) {
                    webviewController = controller;
                    webviewController->get_CoreWebView2(&webviewWindow);
                }
                
                // Add a few settings for the webview
                // The demo step is redundant since the values are the default settings
                ICoreWebView2Settings* Settings;
                webviewWindow->get_Settings(&Settings);
                Settings->put_IsScriptEnabled(TRUE);
                Settings->put_AreDefaultScriptDialogsEnabled(TRUE);
                Settings->put_IsWebMessageEnabled(TRUE);
                
                // Resize WebView to fit the bounds of the parent window
                RECT bounds;
                GetClientRect(hWnd, &bounds);
                webviewController->put_Bounds(bounds);
                
                // Schedule an async task to navigate to Bing
                EventRegistrationToken token;
                webviewWindow->AddWebResourceRequestedFilter(L"*", COREWEBVIEW2_WEB_RESOURCE_CONTEXT_ALL);
                webviewWindow->add_WebResourceRequested(Microsoft::WRL::Callback<ICoreWebView2WebResourceRequestedEventHandler>(
                  [hWnd](ICoreWebView2* sender, ICoreWebView2WebResourceRequestedEventArgs* args) -> HRESULT {
                    // COREWEBVIEW2_WEB_RESOURCE_CONTEXT resourceContext;
                    // args->get_ResourceContext(&resourceContext);
                    // // Ensure that the type is image
                    // if (resourceContext != COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE)
                    // {
                    //     return E_INVALIDARG;
                    // }
                    ICoreWebView2WebResourceRequest* request;
                    args->get_Request(&request);
                    wil::unique_cotaskmem_string uri;
                    request->get_Uri(&uri);
                    std::wcout << uri.get() << std::endl;
                    // // Override the response with an empty one to block the image.
                    // // If put_Response is not called, the request will continue as normal.
                    // wil::com_ptr<ICoreWebView2WebResourceResponse> response;
                    // CHECK_FAILURE(m_webViewEnvironment->CreateWebResourceResponse(
                    //     nullptr, 403 /*NoContent*/, L"Blocked", L"", &response));
                    // CHECK_FAILURE(args->put_Response(response.get()));
                    return E_INVALIDARG;
                  }
                ).Get(), &token);
                std::cout << webviewWindow <<  ":" << webviewWindow->Navigate(L"https://www.acfun.cn/bangumi/aa6001745") << std::endl;
                
                // // Step 4 - Navigation events
                
                // // Step 5 - Scripting
                
                // // Step 6 - Communication between host and web content
                
                return S_OK;
            }).Get());
        return S_OK;
    }).Get());
}

void releaseWebview() {
  if (webviewController)
  {
    webviewController->Close();
    webviewController = nullptr;
    webviewWindow = nullptr;
  }
}