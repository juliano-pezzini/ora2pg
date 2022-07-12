-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW alto_custo_cancer_v3_v (dt_generate, nr_seq_alto_custo, cd_campo_36, cd_campo_10, cd_campo_37, cd_campo_38, cd_campo_39, cd_campo_220, cd_campo_43, cd_campo_44, cd_campo_45, cd_campo_20, cd_campo_40, cd_campo_30, cd_campo_50, cd_campo_60, dt_campo_70, cd_campo_80, cd_campo_47, cd_campo_48, cd_campo_49, cd_campo_69, cd_campo_51, cd_campo_52, cd_campo_53, cd_campo_54, cd_campo_55, cd_campo_56, cd_campo_57, cd_campo_221, cd_campo_68, cd_campo_70, cd_campo_71, cd_campo_74, cd_campo_75, cd_campo_76, cd_campo_77, cd_campo_78, cd_campo_72, cd_campo_81, cd_campo_82, cd_campo_83, cd_campo_84, cd_campo_86, cd_campo_87, cd_campo_88, cd_campo_90, cd_campo_91, cd_campo_92, cd_campo_93, cd_campo_94, cd_campo_95, cd_campo_96, cd_campo_97, cd_campo_98, cd_campo_99, cd_campo_100, cd_campo_101, cd_campo_102, cd_campo_103, cd_campo_104, cd_campo_105, cd_campo_106, cd_campo_107, cd_campo_108, cd_campo_109, cd_campo_110, cd_campo_111, cd_campo_112, cd_campo_113, cd_campo_114, cd_campo_115, cd_campo_116, cd_campo_117, cd_campo_118, cd_campo_119, cd_campo_120, cd_campo_121, cd_campo_122, cd_campo_123, cd_campo_124, cd_campo_125, cd_campo_126, cd_campo_127, cd_campo_128, cd_campo_129, cd_campo_130, cd_campo_131, cd_campo_132, cd_campo_133, cd_campo_134, cd_campo_135, cd_campo_136, cd_campo_137, cd_campo_138, cd_campo_139, cd_campo_140, cd_campo_141, cd_campo_142, cd_campo_143, cd_campo_144, cd_campo_146, cd_campo_147, cd_campo_148, cd_campo_149, cd_campo_152, cd_campo_150, cd_campo_151, cd_campo_153, cd_campo_154, cd_campo_155, cd_campo_156, cd_campo_157, cd_campo_159, cd_campo_160, cd_campo_161, cd_campo_162, cd_campo_163, cd_campo_164, cd_campo_165, cd_campo_166, cd_campo_167, cd_campo_168, cd_campo_169, cd_campo_170, cd_campo_171, cd_campo_172, cd_campo_173, cd_campo_174, cd_campo_175, cd_campo_176, cd_campo_177, cd_campo_178, cd_campo_179, cd_campo_180, cd_campo_181, cd_campo_182, cd_campo_183, cd_campo_184, cd_campo_186, cd_campo_187, cd_campo_188, cd_campo_189, cd_campo_190, cd_campo_191, cd_campo_192, cd_campo_193, cd_campo_194, cd_campo_195, cd_campo_196, cd_campo_197, cd_campo_198, cd_campo_199, cd_campo_200, cd_campo_201, cd_campo_202, cd_campo_203, cd_campo_204, cd_campo_205, cd_campo_222, cd_campo_223, cd_campo_209, cd_campo_210) AS select	a.DT_GENERATE, a.NR_SEQ_ALTO_CUSTO,
 substr(obter_result_anzics_value(a.nr_sequencia,3123),1,4) CD_CAMPO_36,
 substr(obter_result_anzics_value(a.nr_sequencia,3130),1,20) CD_CAMPO_10,
 substr(obter_result_anzics_value(a.nr_sequencia,3124),1,1) CD_CAMPO_37,
 substr(obter_result_anzics_value(a.nr_sequencia,3125),1,6) CD_CAMPO_38,
 obter_result_anzics_number(a.nr_sequencia,3126) CD_CAMPO_39,
 substr(obter_result_anzics_value(a.nr_sequencia,3122),1,2) CD_CAMPO_220,
 substr(obter_result_anzics_value(a.nr_sequencia,3127),1,5) CD_CAMPO_43,
 substr(obter_result_anzics_value(a.nr_sequencia,3128),1,21) CD_CAMPO_44,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3129), 'YYYY-MM-DD'), obter_anzics_value_default(3129)) CD_CAMPO_45,
 substr(obter_result_anzics_value(a.nr_sequencia,3131),1,30) CD_CAMPO_20,
 substr(obter_result_anzics_value(a.nr_sequencia,3117),1,30) CD_CAMPO_40,
 substr(obter_result_anzics_value(a.nr_sequencia,3132),1,20) CD_CAMPO_30,
 substr(obter_result_anzics_value(a.nr_sequencia,3119),1,2) CD_CAMPO_50,
 substr(obter_result_anzics_value(a.nr_sequencia,3120),1,20) CD_CAMPO_60,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3121), 'YYYY-MM-DD'), obter_anzics_value_default(3121)) DT_CAMPO_70,
 substr(obter_result_anzics_value(a.nr_sequencia,3118),1,1) CD_CAMPO_80,
 substr(obter_result_anzics_value(a.nr_sequencia,3042),1,4) CD_CAMPO_47,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3043), 'YYYY-MM-DD'), obter_anzics_value_default(3043)) CD_CAMPO_48,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3044), 'YYYY-MM-DD'), obter_anzics_value_default(3044)) CD_CAMPO_49,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3045), 'YYYY-MM-DD'), obter_anzics_value_default(3045)) CD_CAMPO_69,
 substr(obter_result_anzics_value(a.nr_sequencia,3029),1,2) CD_CAMPO_51,
 substr(obter_result_anzics_value(a.nr_sequencia,3030),1,2) CD_CAMPO_52,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3046), 'YYYY-MM-DD'), obter_anzics_value_default(3046)) CD_CAMPO_53,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3047), 'YYYY-MM-DD'), obter_anzics_value_default(3047)) CD_CAMPO_54,
 substr(obter_result_anzics_value(a.nr_sequencia,3048),1,12) CD_CAMPO_55,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3049), 'YYYY-MM-DD'), obter_anzics_value_default(3049)) CD_CAMPO_56,
 substr(obter_result_anzics_value(a.nr_sequencia,3031),1,2) CD_CAMPO_57,
 substr(obter_result_anzics_value(a.nr_sequencia,3032),1,2) CD_CAMPO_221,
 substr(obter_result_anzics_value(a.nr_sequencia,3033),1,2) CD_CAMPO_68,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3050), 'YYYY-MM-DD'), obter_anzics_value_default(3050)) CD_CAMPO_70,
 obter_result_anzics_number(a.nr_sequencia,3028) CD_CAMPO_71,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3051), 'YYYY-MM-DD'), obter_anzics_value_default(3051)) CD_CAMPO_74,
 obter_result_anzics_number(a.nr_sequencia,3034) CD_CAMPO_75,
 substr(obter_result_anzics_value(a.nr_sequencia,3035),1,2) CD_CAMPO_76,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3052), 'YYYY-MM-DD'), obter_anzics_value_default(3052)) CD_CAMPO_77,
 substr(obter_result_anzics_value(a.nr_sequencia,3036),1,2) CD_CAMPO_78,
 obter_result_anzics_number(a.nr_sequencia,3037) CD_CAMPO_72,
 obter_result_anzics_number(a.nr_sequencia,3038) CD_CAMPO_81,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3039), 'YYYY-MM-DD'), obter_anzics_value_default(3039)) CD_CAMPO_82,
 obter_result_anzics_number(a.nr_sequencia,3040) CD_CAMPO_83,
 obter_result_anzics_number(a.nr_sequencia,3041) CD_CAMPO_84,
 obter_result_anzics_number(a.nr_sequencia,3053) CD_CAMPO_86,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3054), 'YYYY-MM-DD'), obter_anzics_value_default(3054)) CD_CAMPO_87,
 substr(obter_result_anzics_value(a.nr_sequencia,3055),1,4) CD_CAMPO_88,
 obter_result_anzics_number(a.nr_sequencia,3181) CD_CAMPO_90,
 obter_result_anzics_number(a.nr_sequencia,3182) CD_CAMPO_91,
 obter_result_anzics_number(a.nr_sequencia,3183) CD_CAMPO_92,
 obter_result_anzics_number(a.nr_sequencia,3184) CD_CAMPO_93,
 obter_result_anzics_number(a.nr_sequencia,3185) CD_CAMPO_94,
 obter_result_anzics_number(a.nr_sequencia,3186) CD_CAMPO_95,
 obter_result_anzics_number(a.nr_sequencia,3187) CD_CAMPO_96,
 obter_result_anzics_number(a.nr_sequencia,3133) CD_CAMPO_97,
 obter_result_anzics_number(a.nr_sequencia,3134) CD_CAMPO_98,
 obter_result_anzics_number(a.nr_sequencia,3135) CD_CAMPO_99,
 obter_result_anzics_number(a.nr_sequencia,3136) CD_CAMPO_100,
 obter_result_anzics_number(a.nr_sequencia,3137) CD_CAMPO_101,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3138), 'YYYY-MM-DD'), obter_anzics_value_default(3138)) CD_CAMPO_102,
 obter_result_anzics_number(a.nr_sequencia,3139) CD_CAMPO_103,
 substr(obter_result_anzics_value(a.nr_sequencia,3140),1,12) CD_CAMPO_104,
 substr(obter_result_anzics_value(a.nr_sequencia,3141),1,12) CD_CAMPO_105,
 obter_result_anzics_number(a.nr_sequencia,3142) CD_CAMPO_106,
 obter_result_anzics_number(a.nr_sequencia,3143) CD_CAMPO_107,
 obter_result_anzics_number(a.nr_sequencia,3144) CD_CAMPO_108,
 obter_result_anzics_number(a.nr_sequencia,3145) CD_CAMPO_109,
 obter_result_anzics_number(a.nr_sequencia,3146) CD_CAMPO_110,
 obter_result_anzics_number(a.nr_sequencia,3147) CD_CAMPO_111,
 obter_result_anzics_number(a.nr_sequencia,3148) CD_CAMPO_112,
 obter_result_anzics_number(a.nr_sequencia,3149) CD_CAMPO_113,
 obter_result_anzics_number(a.nr_sequencia,3150) CD_CAMPO_114,
 obter_result_anzics_number(a.nr_sequencia,3151) CD_CAMPO_115,
 substr(obter_result_anzics_value(a.nr_sequencia,3152),1,2) CD_CAMPO_116,
 substr(obter_result_anzics_value(a.nr_sequencia,3153),1,2) CD_CAMPO_117,
 substr(obter_result_anzics_value(a.nr_sequencia,3154),1,2) CD_CAMPO_118,
 obter_result_anzics_number(a.nr_sequencia,3155) CD_CAMPO_119,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3156), 'YYYY-MM-DD'), obter_anzics_value_default(3156)) CD_CAMPO_120,
 obter_result_anzics_number(a.nr_sequencia,3157) CD_CAMPO_121,
 obter_result_anzics_number(a.nr_sequencia,3158) CD_CAMPO_122,
 obter_result_anzics_number(a.nr_sequencia,3159) CD_CAMPO_123,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3160), 'YYYY-MM-DD'), obter_anzics_value_default(3160)) CD_CAMPO_124,
 obter_result_anzics_number(a.nr_sequencia,3161) CD_CAMPO_125,
 substr(obter_result_anzics_value(a.nr_sequencia,3162),1,12) CD_CAMPO_126,
 substr(obter_result_anzics_value(a.nr_sequencia,3163),1,12) CD_CAMPO_127,
 obter_result_anzics_number(a.nr_sequencia,3164) CD_CAMPO_128,
 obter_result_anzics_number(a.nr_sequencia,3165) CD_CAMPO_129,
 obter_result_anzics_number(a.nr_sequencia,3166) CD_CAMPO_130,
 obter_result_anzics_number(a.nr_sequencia,3167) CD_CAMPO_131,
 obter_result_anzics_number(a.nr_sequencia,3168) CD_CAMPO_132,
 obter_result_anzics_number(a.nr_sequencia,3169) CD_CAMPO_133,
 obter_result_anzics_number(a.nr_sequencia,3170) CD_CAMPO_134,
 obter_result_anzics_number(a.nr_sequencia,3171) CD_CAMPO_135,
 obter_result_anzics_number(a.nr_sequencia,3172) CD_CAMPO_136,
 obter_result_anzics_number(a.nr_sequencia,3173) CD_CAMPO_137,
 substr(obter_result_anzics_value(a.nr_sequencia,3174),1,2) CD_CAMPO_138,
 substr(obter_result_anzics_value(a.nr_sequencia,3175),1,2) CD_CAMPO_139,
 substr(obter_result_anzics_value(a.nr_sequencia,3176),1,2) CD_CAMPO_140,
 obter_result_anzics_number(a.nr_sequencia,3177) CD_CAMPO_141,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3178), 'YYYY-MM-DD'), obter_anzics_value_default(3178)) CD_CAMPO_142,
 obter_result_anzics_number(a.nr_sequencia,3179) CD_CAMPO_143,
 obter_result_anzics_number(a.nr_sequencia,3180) CD_CAMPO_144,
 obter_result_anzics_number(a.nr_sequencia,3056) CD_CAMPO_146,
 obter_result_anzics_number(a.nr_sequencia,3057) CD_CAMPO_147,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3058), 'YYYY-MM-DD'), obter_anzics_value_default(3058)) CD_CAMPO_148,
 substr(obter_result_anzics_value(a.nr_sequencia,3059),1,12) CD_CAMPO_149,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3062), 'YYYY-MM-DD'), obter_anzics_value_default(3062)) CD_CAMPO_152,
 substr(obter_result_anzics_value(a.nr_sequencia,3060),1,20) CD_CAMPO_150,
 obter_result_anzics_number(a.nr_sequencia,3061) CD_CAMPO_151,
 obter_result_anzics_number(a.nr_sequencia,3063) CD_CAMPO_153,
 substr(obter_result_anzics_value(a.nr_sequencia,3064),1,12) CD_CAMPO_154,
 substr(obter_result_anzics_value(a.nr_sequencia,3065),1,20) CD_CAMPO_155,
 obter_result_anzics_number(a.nr_sequencia,3066) CD_CAMPO_156,
 obter_result_anzics_number(a.nr_sequencia,3067) CD_CAMPO_157,
 obter_result_anzics_number(a.nr_sequencia,3077) CD_CAMPO_159,
 obter_result_anzics_number(a.nr_sequencia,3078) CD_CAMPO_160,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3079), 'YYYY-MM-DD'), obter_anzics_value_default(3079)) CD_CAMPO_161,
 obter_result_anzics_number(a.nr_sequencia,3080) CD_CAMPO_162,
 obter_result_anzics_number(a.nr_sequencia,3081) CD_CAMPO_163,
 obter_result_anzics_number(a.nr_sequencia,3082) CD_CAMPO_164,
 substr(obter_result_anzics_value(a.nr_sequencia,3083),1,12) CD_CAMPO_165,
 substr(obter_result_anzics_value(a.nr_sequencia,3084),1,12) CD_CAMPO_166,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3085), 'YYYY-MM-DD'), obter_anzics_value_default(3085)) CD_CAMPO_167,
 obter_result_anzics_number(a.nr_sequencia,3086) CD_CAMPO_168,
 obter_result_anzics_number(a.nr_sequencia,3087) CD_CAMPO_169,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3068), 'YYYY-MM-DD'), obter_anzics_value_default(3068)) CD_CAMPO_170,
 obter_result_anzics_number(a.nr_sequencia,3069) CD_CAMPO_171,
 obter_result_anzics_number(a.nr_sequencia,3070) CD_CAMPO_172,
 obter_result_anzics_number(a.nr_sequencia,3071) CD_CAMPO_173,
 substr(obter_result_anzics_value(a.nr_sequencia,3072),1,2) CD_CAMPO_174,
 substr(obter_result_anzics_value(a.nr_sequencia,3073),1,2) CD_CAMPO_175,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3074), 'YYYY-MM-DD'), obter_anzics_value_default(3074)) CD_CAMPO_176,
 obter_result_anzics_number(a.nr_sequencia,3075) CD_CAMPO_177,
 obter_result_anzics_number(a.nr_sequencia,3076) CD_CAMPO_178,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3683), 'YYYY-MM-DD'), obter_anzics_value_default(3683)) CD_CAMPO_179,
 obter_result_anzics_number(a.nr_sequencia,3088) CD_CAMPO_180,
 obter_result_anzics_number(a.nr_sequencia,3089) CD_CAMPO_181,
 obter_result_anzics_number(a.nr_sequencia,3090) CD_CAMPO_182,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3091), 'YYYY-MM-DD'), obter_anzics_value_default(3091)) CD_CAMPO_183,
 substr(obter_result_anzics_value(a.nr_sequencia,3092),1,12) CD_CAMPO_184,
 obter_result_anzics_number(a.nr_sequencia,3093) CD_CAMPO_186,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3094), 'YYYY-MM-DD'), obter_anzics_value_default(3094)) CD_CAMPO_187,
 substr(obter_result_anzics_value(a.nr_sequencia,3095),1,12) CD_CAMPO_188,
 obter_result_anzics_number(a.nr_sequencia,3096) CD_CAMPO_189,
 obter_result_anzics_number(a.nr_sequencia,3097) CD_CAMPO_190,
 obter_result_anzics_number(a.nr_sequencia,3098) CD_CAMPO_191,
 obter_result_anzics_number(a.nr_sequencia,3099) CD_CAMPO_192,
 obter_result_anzics_number(a.nr_sequencia,3100) CD_CAMPO_193,
 obter_result_anzics_number(a.nr_sequencia,3101) CD_CAMPO_194,
 obter_result_anzics_number(a.nr_sequencia,3102) CD_CAMPO_195,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3103), 'YYYY-MM-DD'), obter_anzics_value_default(3103)) CD_CAMPO_196,
 substr(obter_result_anzics_value(a.nr_sequencia,3104),1,12) CD_CAMPO_197,
 obter_result_anzics_number(a.nr_sequencia,3105) CD_CAMPO_198,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3106), 'YYYY-MM-DD'), obter_anzics_value_default(3106)) CD_CAMPO_199,
 substr(obter_result_anzics_value(a.nr_sequencia,3107),1,12) CD_CAMPO_200,
 obter_result_anzics_number(a.nr_sequencia,3108) CD_CAMPO_201,
 COALESCE(to_char(obter_result_anzics_date(a.nr_sequencia,3109), 'YYYY-MM-DD'), obter_anzics_value_default(3109)) CD_CAMPO_202,
 substr(obter_result_anzics_value(a.nr_sequencia,3110),1,12) CD_CAMPO_203,
 obter_result_anzics_number(a.nr_sequencia,3111) CD_CAMPO_204,
 obter_result_anzics_number(a.nr_sequencia,3112) CD_CAMPO_205,
 substr(obter_result_anzics_value(a.nr_sequencia,3113),1,2) CD_CAMPO_222,
 substr(obter_result_anzics_value(a.nr_sequencia,3116),1,2) CD_CAMPO_223,
 obter_result_anzics_number(a.nr_sequencia,3114) CD_CAMPO_209,
 obter_result_anzics_number(a.nr_sequencia,3115) CD_CAMPO_210
 FROM ATEND_ANZICS a
 where a.NR_SEQ_ANZICS = 37
 
 and a.dt_inativacao is null 
 order by a.DT_GENERATE;
