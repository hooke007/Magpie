// (FSRCNNX_x2_8-0-4-1) mapping 1_1


cbuffer constants : register(b0) {
	int2 srcSize : packoffset(c0.x);
};


#define MAGPIE_INPUT_COUNT 2
#include "FSRCNNX8041.hlsli"

#define get0(pos) uncompressLinear(SampleInput(0, pos), -1, 1.5)
#define get1(pos) uncompressLinear(SampleInput(1, pos), -2, 2)


D2D_PS_ENTRY(main) {
	InitMagpieSampleInput();

	float2 leftTop = GetCheckedOffPos(0, float2(-1, -1));
	float2 rightBottom = GetCheckedOffPos(0, float2(1, 1));

	float4 res = { -0.0445119962096214, -0.7632357478141785, 0.0156328510493040, -0.2424548566341400 };
	res += mul(get0(leftTop), float4x4(0.1279004216194153, -0.0275541823357344, 0.2275633513927460, 0.2241709381341934, 0.0197204202413559, -0.0456816256046295, -0.1296672523021698, 0.0564568229019642, -0.0241488646715879, -0.0237508192658424, -0.1899632662534714, 0.4177669584751129, -0.1814560592174530, -0.0526473335921764, 0.1154382973909378, -0.0715614855289459));
	res += mul(get1(leftTop), float4x4(-0.0660311505198479, 0.0416736751794815, 0.3146112561225891, 0.1472041457891464, -0.3456672728061676, -0.0055983816273510, 0.0022350433282554, 0.0819796621799469, 0.0057485047727823, 0.1532524228096008, 0.0204557459801435, -0.2500547170639038, -0.0524359568953514, -0.1911625266075134, -0.1078366711735725, -0.1296254843473434));
	res += mul(get0(float2(leftTop.x, Coord(0).y)), float4x4(0.0904538556933403, -0.0150672039017081, 0.3322310745716095, 0.0638923197984695, 0.5975797176361084, -0.2452044337987900, -0.4947478473186493, -0.0783191770315170, 0.5771877169609070, -0.0870653912425041, -0.8966570496559143, -0.2140965163707733, -0.0493861362338066, -0.0380848757922649, -0.1345319598913193, -0.0186063013970852));
	res += mul(get1(float2(leftTop.x, Coord(0).y)), float4x4(-0.2523841261863708, 0.1387074738740921, 0.7878478765487671, -0.2251627445220947, 0.2277439534664154, 0.5417668819427490, 0.0866540968418121, -0.1707777529954910, -0.0598246827721596, -0.4717158675193787, -1.2242834568023682, 0.0454643070697784, -0.3503442704677582, 0.0573085807263851, 0.2530198395252228, -0.0207283068448305));
	res += mul(get0(float2(leftTop.x, rightBottom.y)), float4x4(0.0168380383402109, -0.2142438590526581, -0.0207892972975969, 0.3628533780574799, 0.2431225180625916, 0.3098322153091431, 0.4073205888271332, -0.2762102782726288, -0.0197229012846947, 0.1305596232414246, -0.5697882771492004, -0.2976251542568207, -0.0551432967185974, 0.2614036500453949, -0.1410341411828995, -0.2906406223773956));
	res += mul(get1(float2(leftTop.x, rightBottom.y)), float4x4(-0.0498303361237049, 0.0224859956651926, 0.1952174901962280, -0.0311204437166452, 0.2501715123653412, -0.5893352627754211, -1.0793941020965576, 0.0160885509103537, 0.5081620812416077, 0.0482814386487007, 0.0546359121799469, -0.0501569248735905, 0.1400523334741592, -0.0106841633096337, -0.0940591320395470, -0.1791856139898300));
	res += mul(get0(float2(Coord(0).x, leftTop.y)), float4x4(0.0393299944698811, 0.2232691347599030, -0.1055066883563995, -0.1607919186353683, -0.1567825973033905, -0.0042221010662615, -0.0548228211700916, 0.2352052628993988, 0.1483389288187027, 0.7503526806831360, 0.0797731876373291, -0.0049001369625330, -0.0242983382195234, -0.0308702979236841, 0.0828925222158432, 0.0561857633292675));
	res += mul(get1(float2(Coord(0).x, leftTop.y)), float4x4(0.0926392748951912, -0.0418718457221985, -0.3060409128665924, -0.1883587390184402, 0.0284292586147785, -0.3584854304790497, -0.7909982800483704, -0.0187337957322598, -0.2496993243694305, -0.7520986795425415, 0.3771523833274841, -0.0259053874760866, 0.0337998159229755, 0.2209153026342392, 0.0708771497011185, -0.2814430892467499));
	res += mul(get0(Coord(0).xy), float4x4(-0.5287809371948242, 0.5777525901794434, 0.0880500450730324, -0.8452472090721130, -0.3393408954143524, -0.2273543328046799, -0.1298527419567108, 0.4990308582782745, 1.2613251209259033, -0.7636719942092896, 1.5694186687469482, -0.4087363779544830, 0.0874531939625740, 0.7067158818244934, -0.3419588804244995, -0.3265531957149506));
	res += mul(get1(Coord(0).xy), float4x4(0.8229957222938538, -0.1236215904355049, -0.1859253048896790, 1.6684840917587280, 0.2000777721405029, -0.1239093989133835, 1.5623438358306885, 0.1779983490705490, 0.1017884835600853, -0.3707404434680939, 1.0626678466796875, -0.3124029338359833, 0.0659058541059494, -0.3585464656352997, -0.1866402775049210, 0.6733445525169373));
	res += mul(get0(float2(Coord(0).x, rightBottom.y)), float4x4(-0.5544115900993347, -0.1892931908369064, 0.2460739761590958, -0.1056193932890892, -0.4318082630634308, 0.1257930994033813, -0.2672747671604156, -0.1690235435962677, 0.0018221997888759, -0.4397548139095306, -0.3007801771163940, 0.1068472340703011, 0.3506655991077423, 0.1143834441900253, 0.1363849341869354, -0.1417382210493088));
	res += mul(get1(float2(Coord(0).x, rightBottom.y)), float4x4(-0.0505668744444847, 0.1831464916467667, 0.3957343697547913, -0.2295413911342621, -0.3892803490161896, 0.5436951518058777, 0.1217770799994469, 0.0223295800387859, -0.4462866187095642, -0.4055982232093811, -0.3771279454231262, 0.0807068347930908, 0.2116729617118835, 0.0281026475131512, -0.0229265503585339, 0.2868605256080627));
	res += mul(get0(float2(rightBottom.x, leftTop.y)), float4x4(0.1962712109088898, -0.2373334914445877, -2.5208437442779541, -0.1988540291786194, 0.2224564403295517, -0.1783192902803421, -0.3962321281433105, -0.1685980409383774, 0.1910390257835388, 0.2554391324520111, 0.4586416482925415, 0.2779130041599274, -0.2002453953027725, -0.0061091855168343, 1.3808131217956543, 0.0434907525777817));
	res += mul(get1(float2(rightBottom.x, leftTop.y)), float4x4(-0.0307611189782619, -0.0524470545351505, -0.5897512435913086, -0.0816674903035164, 0.4052906930446625, 0.2542210817337036, -1.9041002988815308, 0.0835462361574173, -0.2484460622072220, -0.0184739269316196, 0.4510098397731781, 0.2587619423866272, 0.1537084281444550, 0.1503131389617920, -0.0742949545383453, 0.0613216012716293));
	res += mul(get0(float2(rightBottom.x, Coord(0).y)), float4x4(0.1772638261318207, 0.0948876664042473, 0.0083848545327783, -0.2919732332229614, 0.2566950321197510, 0.0288751143962145, -0.4624863862991333, -0.0608786940574646, 0.3310996592044830, -0.0104284398257732, 0.6334818005561829, -0.0027201652992517, -0.0342350602149963, 0.1938806027173996, -0.2464301586151123, 0.0125883584842086));
	res += mul(get1(float2(rightBottom.x, Coord(0).y)), float4x4(0.4839433431625366, -0.0502159744501114, -1.1114163398742676, -0.3965759575366974, 0.2117286175489426, 0.0414481423795223, -0.1332397013902664, -0.0549883767962456, -0.1275007277727127, 0.7844302654266357, -0.0095163453370333, 0.0961041301488876, -0.4759134948253632, -0.4284025132656097, -0.2072399407625198, -0.3953579664230347));
	res += mul(get0(rightBottom), float4x4(0.1605869531631470, -0.1715892106294632, 0.0865620598196983, -0.0464400537312031, -0.2688548862934113, 0.1722514480352402, 0.0167612321674824, -0.0032994034700096, -0.3451044559478760, -0.2280300110578537, -0.0029796555172652, -0.1597652435302734, 0.0500137843191624, 0.1023071259260178, -0.0407028235495090, 0.2228624969720840));
	res += mul(get1(rightBottom), float4x4(0.6999920010566711, 0.0839441940188408, 0.0815469548106194, -0.1509176045656204, -0.0690853074193001, -0.3200871348381042, 0.0780162736773491, -0.1449639797210693, 0.2868815064430237, 0.3962450027465820, -0.3439113497734070, 0.2657423913478851, 0.0988137871026993, 0.3471299111843109, -0.2186402678489685, -0.0648017078638077));
	res = max(res, ZEROS4) + float4(1.0311057567596436, 0.1051208898425102, 0.1158760935068130, 0.0466635078191757) * min(res, ZEROS4);

	return compressTan(res);
}
