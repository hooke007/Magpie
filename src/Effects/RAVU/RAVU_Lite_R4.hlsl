// This file is generated by the scripts available at https://github.com/hauuau/magpie-prescalers
// Please don't edit this file directly.
// Generated by: ravu-lite.py --weights-file weights\ravu-lite_weights-r4.py --float-format float16dx --use-compute-shader --use-magpie --overwrite
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//!MAGPIE EFFECT
//!VERSION 4

//!TEXTURE
Texture2D INPUT;

//!SAMPLER
//!FILTER POINT
SamplerState sam_INPUT;

//!TEXTURE
//!WIDTH  INPUT_WIDTH * 2
//!HEIGHT INPUT_HEIGHT * 2
Texture2D OUTPUT;

//!SAMPLER
//!FILTER LINEAR
SamplerState sam_INPUT_LINEAR;

//!TEXTURE
//!SOURCE ravu_lite_lut4_f16.dds
//!FORMAT R16G16B16A16_FLOAT
Texture2D ravu_lite_lut4;

//!SAMPLER
//!FILTER LINEAR
SamplerState sam_ravu_lite_lut4;

//!COMMON
#include "prescalers.hlsli"

#define LAST_PASS 1

//!PASS 1
//!DESC RAVU-Lite (r4, compute)
//!IN INPUT, ravu_lite_lut4
//!OUT OUTPUT
//!BLOCK_SIZE 64, 16
//!NUM_THREADS 32, 8
shared float inp[532];

#define CURRENT_PASS 1

#define GET_SAMPLE(x) dot(x.rgb, rgb2y)
#define imageStore(out_image, pos, val) imageStoreOverride(pos, val.x)
void imageStoreOverride(uint2 pos, float value) {
	float2 UV = mul(rgb2uv, INPUT.SampleLevel(sam_INPUT_LINEAR, HOOKED_map(pos), 0).rgb);
	OUTPUT[pos] = float4(mul(yuv2rgb, float3(value.x, UV)), 1.0);
}

#define INPUT_tex(pos) GET_SAMPLE(vec4(texture(INPUT, pos)))
static const float2 INPUT_size = float2(GetInputSize());
static const float2 INPUT_pt = float2(GetInputPt());

#define ravu_lite_lut4_tex(pos) (vec4(texture(ravu_lite_lut4, pos)))

#define HOOKED_tex(pos) INPUT_tex(pos)
#define HOOKED_size INPUT_size
#define HOOKED_pt INPUT_pt

void Pass1(uint2 blockStart, uint3 threadId) {
	ivec2 group_base = ivec2(gl_WorkGroupID) * ivec2(gl_WorkGroupSize);
	int local_pos = int(gl_LocalInvocationID.x) * 14 + int(gl_LocalInvocationID.y);
#pragma warning(disable : 3557)
	for (int id = int(gl_LocalInvocationIndex); id < 532; id += int(gl_WorkGroupSize.x * gl_WorkGroupSize.y)) {
		uint x = (uint)id / 14, y = (uint)id % 14;
		inp[id] = HOOKED_tex(HOOKED_pt * vec2(float(group_base.x + x) + (-2.5), float(group_base.y + y) + (-2.5))).x;
	}
	barrier();
#if CURRENT_PASS == LAST_PASS
	uint2 destPos = blockStart + threadId.xy * 2;
	uint2 outputSize = GetOutputSize();
	if (destPos.x >= outputSize.x || destPos.y >= outputSize.y) {
		return;
	}
#endif
	vec3 abd = vec3(0.0, 0.0, 0.0);
	float gx, gy;
	gx = (inp[local_pos + 29] - inp[local_pos + 1]) / 2.0;
	gy = (inp[local_pos + 16] - inp[local_pos + 14]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.02324683987829437;
	gx = (inp[local_pos + 30] - inp[local_pos + 2]) / 2.0;
	gy = (inp[local_pos + 17] - inp[local_pos + 15]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 31] - inp[local_pos + 3]) / 2.0;
	gy = (inp[local_pos + 18] - inp[local_pos + 16]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.038327559383903906;
	gx = (inp[local_pos + 32] - inp[local_pos + 4]) / 2.0;
	gy = (inp[local_pos + 19] - inp[local_pos + 17]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 33] - inp[local_pos + 5]) / 2.0;
	gy = (inp[local_pos + 20] - inp[local_pos + 18]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.02324683987829437;
	gx = (inp[local_pos + 43] - inp[local_pos + 15]) / 2.0;
	gy = (inp[local_pos + 30] - inp[local_pos + 28]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 44] - inp[local_pos + 16]) / 2.0;
	gy = (inp[local_pos + 31] - inp[local_pos + 29]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04921356040854137;
	gx = (inp[local_pos + 45] - inp[local_pos + 17]) / 2.0;
	gy = (inp[local_pos + 32] - inp[local_pos + 30]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.055766269846849466;
	gx = (inp[local_pos + 46] - inp[local_pos + 18]) / 2.0;
	gy = (inp[local_pos + 33] - inp[local_pos + 31]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04921356040854137;
	gx = (inp[local_pos + 47] - inp[local_pos + 19]) / 2.0;
	gy = (inp[local_pos + 34] - inp[local_pos + 32]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 57] - inp[local_pos + 29]) / 2.0;
	gy = (inp[local_pos + 44] - inp[local_pos + 42]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.038327559383903906;
	gx = (inp[local_pos + 58] - inp[local_pos + 30]) / 2.0;
	gy = (inp[local_pos + 45] - inp[local_pos + 43]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.055766269846849466;
	gx = (inp[local_pos + 59] - inp[local_pos + 31]) / 2.0;
	gy = (inp[local_pos + 46] - inp[local_pos + 44]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.06319146241026467;
	gx = (inp[local_pos + 60] - inp[local_pos + 32]) / 2.0;
	gy = (inp[local_pos + 47] - inp[local_pos + 45]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.055766269846849466;
	gx = (inp[local_pos + 61] - inp[local_pos + 33]) / 2.0;
	gy = (inp[local_pos + 48] - inp[local_pos + 46]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.038327559383903906;
	gx = (inp[local_pos + 71] - inp[local_pos + 43]) / 2.0;
	gy = (inp[local_pos + 58] - inp[local_pos + 56]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 72] - inp[local_pos + 44]) / 2.0;
	gy = (inp[local_pos + 59] - inp[local_pos + 57]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04921356040854137;
	gx = (inp[local_pos + 73] - inp[local_pos + 45]) / 2.0;
	gy = (inp[local_pos + 60] - inp[local_pos + 58]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.055766269846849466;
	gx = (inp[local_pos + 74] - inp[local_pos + 46]) / 2.0;
	gy = (inp[local_pos + 61] - inp[local_pos + 59]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.04921356040854137;
	gx = (inp[local_pos + 75] - inp[local_pos + 47]) / 2.0;
	gy = (inp[local_pos + 62] - inp[local_pos + 60]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 85] - inp[local_pos + 57]) / 2.0;
	gy = (inp[local_pos + 72] - inp[local_pos + 70]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.02324683987829437;
	gx = (inp[local_pos + 86] - inp[local_pos + 58]) / 2.0;
	gy = (inp[local_pos + 73] - inp[local_pos + 71]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 87] - inp[local_pos + 59]) / 2.0;
	gy = (inp[local_pos + 74] - inp[local_pos + 72]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.038327559383903906;
	gx = (inp[local_pos + 88] - inp[local_pos + 60]) / 2.0;
	gy = (inp[local_pos + 75] - inp[local_pos + 73]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.033823952439922346;
	gx = (inp[local_pos + 89] - inp[local_pos + 61]) / 2.0;
	gy = (inp[local_pos + 76] - inp[local_pos + 74]) / 2.0;
	abd += vec3(gx * gx, gx * gy, gy * gy) * 0.02324683987829437;
	float a = abd.x, b = abd.y, d = abd.z;
	float T = a + d, D = a * d - b * b;
	float delta = sqrt(max(T * T / 4.0 - D, 0.0));
	float L1 = T / 2.0 + delta, L2 = T / 2.0 - delta;
	float sqrtL1 = sqrt(L1), sqrtL2 = sqrt(L2);
	float theta = mix(mod(atan(L1 - a, b) + 3.141592653589793, 3.141592653589793), 0.0, abs(b) < 1.192092896e-7);
	float lambda = sqrtL1;
	float mu = mix((sqrtL1 - sqrtL2) / (sqrtL1 + sqrtL2), 0.0, sqrtL1 + sqrtL2 < 1.192092896e-7);
	float angle = floor(theta * 24.0 / 3.141592653589793);
	float strength = mix(mix(0.0, 1.0, lambda >= 0.004), mix(2.0, 3.0, lambda >= 0.05), lambda >= 0.016);
	float coherence = mix(mix(0.0, 1.0, mu >= 0.25), 2.0, mu >= 0.5);
	float coord_y = ((angle * 4.0 + strength) * 3.0 + coherence + 0.5) / 288.0;
	vec4 res = vec4(0.0, 0.0, 0.0, 0.0), w;
	w = texture(ravu_lite_lut4, vec2(0.02, coord_y));
	res += inp[local_pos + 0] * w + inp[local_pos + 90] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.06, coord_y));
	res += inp[local_pos + 1] * w + inp[local_pos + 89] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.1, coord_y));
	res += inp[local_pos + 2] * w + inp[local_pos + 88] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.14, coord_y));
	res += inp[local_pos + 3] * w + inp[local_pos + 87] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.18, coord_y));
	res += inp[local_pos + 4] * w + inp[local_pos + 86] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.22, coord_y));
	res += inp[local_pos + 5] * w + inp[local_pos + 85] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.26, coord_y));
	res += inp[local_pos + 6] * w + inp[local_pos + 84] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.3, coord_y));
	res += inp[local_pos + 14] * w + inp[local_pos + 76] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.34, coord_y));
	res += inp[local_pos + 15] * w + inp[local_pos + 75] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.38, coord_y));
	res += inp[local_pos + 16] * w + inp[local_pos + 74] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.42, coord_y));
	res += inp[local_pos + 17] * w + inp[local_pos + 73] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.46, coord_y));
	res += inp[local_pos + 18] * w + inp[local_pos + 72] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.5, coord_y));
	res += inp[local_pos + 19] * w + inp[local_pos + 71] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.54, coord_y));
	res += inp[local_pos + 20] * w + inp[local_pos + 70] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.58, coord_y));
	res += inp[local_pos + 28] * w + inp[local_pos + 62] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.62, coord_y));
	res += inp[local_pos + 29] * w + inp[local_pos + 61] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.66, coord_y));
	res += inp[local_pos + 30] * w + inp[local_pos + 60] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.7, coord_y));
	res += inp[local_pos + 31] * w + inp[local_pos + 59] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.74, coord_y));
	res += inp[local_pos + 32] * w + inp[local_pos + 58] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.78, coord_y));
	res += inp[local_pos + 33] * w + inp[local_pos + 57] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.82, coord_y));
	res += inp[local_pos + 34] * w + inp[local_pos + 56] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.86, coord_y));
	res += inp[local_pos + 42] * w + inp[local_pos + 48] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.9, coord_y));
	res += inp[local_pos + 43] * w + inp[local_pos + 47] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.94, coord_y));
	res += inp[local_pos + 44] * w + inp[local_pos + 46] * w.wzyx;
	w = texture(ravu_lite_lut4, vec2(0.98, coord_y));
	res += inp[local_pos + 45] * w;
	res = clamp(res, 0.0, 1.0);
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 0), vec4(res[0], 0.0, 0.0, 0.0));
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(0, 1), vec4(res[1], 0.0, 0.0, 0.0));
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 0), vec4(res[2], 0.0, 0.0, 0.0));
	imageStore(out_image, ivec2(gl_GlobalInvocationID) * 2 + ivec2(1, 1), vec4(res[3], 0.0, 0.0, 0.0));
}
