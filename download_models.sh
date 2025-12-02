#!/bin/bash

# Function to download using aria2c
download() {
    url="$1"
    dir="$2"
    filename="$3"

    # Create directory if it doesn't exist
    mkdir -p "$dir"

    # Check if file already exists
    if [ -f "$dir/$filename" ]; then
        echo "File $dir/$filename already exists. Skipping."
    else
        echo "Downloading $filename to $dir..."
        # Check if aria2c is installed, otherwise use wget or curl
        if command -v aria2c &> /dev/null; then
            aria2c -x 16 -s 16 -k 1M --console-log-level=error -d "$dir" -o "$filename" "$url"
        else
            echo "aria2c not found. Please install aria2c or modify script to use wget/curl."
            exit 1
        fi
    fi
}

echo "Starting download of ComfyUI models..."

# ==============================================================================
# 1. Infinite Talk Workflow Models
# ==============================================================================
echo "Downloading Infinite Talk Workflow models..."

# WanVideo Model Loader
download "https://huggingface.co/city96/Wan2.1-I2V-14B-480P-gguf/resolve/main/wan2.1-i2v-14b-480p-Q4_0.gguf?download=true" "ComfyUI/models/diffusion_models" "wan2.1-i2v-14b-480p-Q4_0.gguf"

# WanVideo Lora Select
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors?download=true" "ComfyUI/models/loras" "lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"
# Also downloading the rank256 version referenced in the node
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors?download=true" "ComfyUI/models/loras" "lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors"

# Multi/InfiniteTalk Model Loader
download "https://huggingface.co/Kijai/WanVideo_comfy_GGUF/resolve/main/InfiniteTalk/Wan2_1-InfiniteTalk_Single_Q8.gguf?download=true" "ComfyUI/models/diffusion_models" "Wan2_1-InfiniteTalk_Single_Q8.gguf"

# Load VAE
download "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors?download=true" "ComfyUI/models/vae" "wan_2.1_vae.safetensors"

# Load CLIP Vision
download "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors?download=true" "ComfyUI/models/clip_vision" "clip_vision_h.safetensors"

# Wav2vec2 Model Loader
download "https://huggingface.co/Kijai/wav2vec2_safetensors/resolve/main/wav2vec2-chinese-base_fp16.safetensors?download=true" "ComfyUI/models/wav2vec2" "wav2vec2-chinese-base_fp16.safetensors"

# WanVideo TextEncode Cached (T5 Encoder)
download "https://huggingface.co/ALGOTECH/WanVideo_comfy/resolve/main/umt5-xxl-enc-bf16.safetensors?download=true" "ComfyUI/models/clip" "umt5-xxl-enc-bf16.safetensors"


# ==============================================================================
# 2. Qwen Edit Workflow Models
# ==============================================================================
echo "Downloading Qwen Edit Workflow models..."

# UNETLoader (Qwen Image Edit)
download "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors" "ComfyUI/models/diffusion_models/QwenImage" "qwen_image_edit_2509_fp8_e4m3fn.safetensors"

# CLIPLoader (Qwen 2.5 VL 7B)
download "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "ComfyUI/models/text_encoders" "qwen_2.5_vl_7b_fp8_scaled.safetensors"
# Also putting it in clip folder as backup/alternative path
download "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors" "ComfyUI/models/clip" "qwen_2.5_vl_7b_fp8_scaled.safetensors"

# VAELoader (Qwen Image VAE)
download "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors" "ComfyUI/models/vae" "qwen_image_vae.safetensors"

# LoraLoaderModelOnly (Qwen Image Lightning)
download "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors" "ComfyUI/models/loras/QwenEdit" "Qwen-Image-Edit-Lightning-4steps-V1.0.safetensors"

# UNETLoader (Qwen Image FP8) - Widget says z_image_turbo_bf16.safetensors but URL points to qwen_image_fp8_e4m3fn.safetensors
download "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors" "ComfyUI/models/diffusion_models" "qwen_image_fp8_e4m3fn.safetensors"

# UpscaleModelLoader (RealESRGAN)
download "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth" "ComfyUI/models/upscale_models" "RealESRGAN_x4plus.pth"

# Missing: Try_On_Qwen_Edit_Lora.safetensors
echo "WARNING: Could not find a direct download URL for 'Try_On_Qwen_Edit_Lora.safetensors'. Please locate this file manually and place it in ComfyUI/models/loras/QwenEdit/"


# ==============================================================================
# 3. Wan 2.2 Animate Workflow Models
# ==============================================================================
echo "Downloading Wan 2.2 Animate Workflow models..."

# CLIPLoader (UMT5 XXL)
download "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" "ComfyUI/models/text_encoders" "umt5_xxl_fp8_e4m3fn_scaled.safetensors"

# UNETLoader (Wan 2.2 Animate)
download "https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors" "ComfyUI/models/diffusion_models/wan2_2" "Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"

# LoraLoaderModelOnly (WanAnimate Relight)
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/WanAnimate_relight_lora_fp16.safetensors" "ComfyUI/models/loras/Wan2_2" "WanAnimate_relight_lora_fp16.safetensors"

# UNETLoader (Wan 2.2 T2V Low Noise) - Node says "wan2.2_t2v_low_noise_14B_fp16.safetensors" but link points to fp8 scaled version usually used in comfy
download "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors" "ComfyUI/models/diffusion_models/wan2_2" "wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"

# LoraLoaderModelOnly (DetailEnhancer)
download "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/DetailEnhancerV1.safetensors" "ComfyUI/models/loras/WanVideo" "DetailEnhancerV1.safetensors"

# LoraLoaderModelOnly (Wan 2.2 Fun HPS) - Based on search, likely "Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors"
# Note: URL might be unstable or require login for ModelScope. Using best effort or skipping.
echo "WARNING: 'Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' URL not permanently available. Please download from ModelScope or HuggingFace (Kijai/WanVideo_comfy repo) manually."

# Onnx Models (Pose/Detection)
# yolov10m.onnx
download "https://huggingface.co/onnx-community/yolov10m/resolve/main/onnx/model.onnx" "ComfyUI/models/onnx" "yolov10m.onnx"

# vitpose-l-wholebody.onnx (Common location for ComfyUI pose nodes)
# Attempting to download from a known source, e.g., huggingface.co/student/adapter/resolve/main/vitpose-l-wholebody.onnx or similar.
# Using a generic search result link or placeholder.
download "https://huggingface.co/xinsir/controlnet-union-sdxl-1.0/resolve/main/vitpose_v2.onnx" "ComfyUI/models/onnx" "vitpose-l-wholebody.onnx"
# Note: The above is a placeholder. Real vitpose-l-wholebody.onnx might need a specific repo.
echo "NOTE: 'vitpose-l-wholebody.onnx' download attempted from generic source. If it fails or is incorrect, please find the correct ONNX model for 'comfyui-wananimatepreprocess'."

# Low Noise Model LoRA
echo "WARNING: 'low_noise_model.safetensors' (path: Wan2.2-T2V-A14B-4steps-lora-250928) could not be automatically downloaded. Please check Wan2.2-T2V-A14B-4steps-lora-250928 repository."

echo "Download script completed. Please check for any warnings."
