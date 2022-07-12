-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_ds_fenotipagem (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
ds_d_w	varchar(1);
ds_c_w	varchar(1);
ds_e_w	varchar(1);
ds_c_min_w	varchar(1);
ds_e_min_w	varchar(1);
ds_f_min_w	varchar(1);
ds_cw_w	varchar(1);
ds_k_w	varchar(1);
ds_k_min_w	varchar(1);
ds_kpa_w	varchar(1);
ds_kpb_w	varchar(1);
ds_jsa_w	varchar(1);
ds_jsb_w	varchar(1);
ds_fya_w	varchar(1);
ds_fyb_w	varchar(1);
ds_jka_w	varchar(1);
ds_jkb_w	varchar(1);
ds_lea_w	varchar(1);
ds_leb_w	varchar(1);
ds_s_w	varchar(1);
ds_s_min_w	varchar(1);
ds_m_w	varchar(1);
ds_n_w	varchar(1);
ds_p1_w	varchar(1);
ds_lua_w	varchar(1);
ds_lub_w	varchar(1);
ds_dia_w	varchar(1);


BEGIN
ds_retorno_w := '';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select	ds_d,
		ds_c,
		ds_e,
		ds_c_min,
		ds_e_min,
		ds_f_min,
		ds_cw,
		ds_k,
		ds_k_min,
		ds_kpa,
		ds_kpb,
		ds_jsa,
		ds_jsb,
		ds_fya,
		ds_fyb,
		ds_jka,
		ds_jkb,
		ds_lea,
		ds_leb,
		ds_s,
		ds_s_min,
		ds_m,
		ds_n,
		ds_p1,
		ds_lua,
		ds_lub,
		ds_dia
	into STRICT	ds_d_w,
		ds_c_w,
		ds_e_w,
		ds_c_min_w,
		ds_e_min_w,
		ds_f_min_w,
		ds_cw_w,
		ds_k_w,
		ds_k_min_w,
		ds_kpa_w,
		ds_kpb_w,
		ds_jsa_w,
		ds_jsb_w,
		ds_fya_w,
		ds_fyb_w,
		ds_jka_w,
		ds_jkb_w,
		ds_lea_w,
		ds_leb_w,
		ds_s_w,
		ds_s_min_w,
		ds_m_w,
		ds_n_w,
		ds_p1_w,
		ds_lua_w,
		ds_lub_w,
		ds_dia_w
	from	san_result_fenotipagem
	where	nr_sequencia = nr_sequencia_p;

	if (ds_d_w = '1') then
		ds_retorno_w := 'D+ ';
	elsif (ds_d_w = '0') then
		ds_retorno_w := 'D- ';
	end if;
	if (ds_c_w = '1') then
		ds_retorno_w := ds_retorno_w ||'C+ ';
	elsif (ds_c_w = '0') then
		ds_retorno_w := ds_retorno_w ||'C- ';
	end if;
	if (ds_c_min_w = '1') then
		ds_retorno_w := ds_retorno_w ||'c+ ';
	elsif (ds_c_min_w = '0') then
		ds_retorno_w := ds_retorno_w ||'c- ';
	end if;
	if (ds_e_w = '1') then
		ds_retorno_w := ds_retorno_w ||'E+ ';
	elsif (ds_e_w = '0') then
		ds_retorno_w := ds_retorno_w ||'E- ';
	end if;
	if (ds_e_min_w = '1') then
		ds_retorno_w := ds_retorno_w ||'e+ ';
	elsif (ds_e_min_w = '0') then
		ds_retorno_w := ds_retorno_w ||'e- ';
	end if;
	if (ds_f_min_w = '1') then
		ds_retorno_w := ds_retorno_w ||'f+ ';
	elsif (ds_f_min_w = '0') then
		ds_retorno_w := ds_retorno_w ||'f- ';
	end if;
	if (ds_cw_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Cw+ ';
	elsif (ds_cw_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Cw- ';
	end if;
	if (ds_k_w = '1') then
		ds_retorno_w := ds_retorno_w ||'K+ ';
	elsif (ds_k_w = '0') then
		ds_retorno_w := ds_retorno_w ||'K- ';
	end if;
	if (ds_k_min_w = '1') then
		ds_retorno_w := ds_retorno_w ||'k+ ';
	elsif (ds_k_min_w = '0') then
		ds_retorno_w := ds_retorno_w ||'k- ';
	end if;
	if (ds_kpa_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Kpa+ ';
	elsif (ds_kpa_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Kpa- ';
	end if;
	if (ds_kpb_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Kpb+ ';
	elsif (ds_kpb_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Kpb- ';
	end if;
	if (ds_jsa_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Jsa+ ';
	elsif (ds_jsa_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Jsa- ';
	end if;
	if (ds_jsb_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Jsb+ ';
	elsif (ds_jsb_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Jsb- ';
	end if;
	if (ds_fya_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Fya+ ';
	elsif (ds_fya_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Fya- ';
	end if;
	if (ds_fyb_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Fyb+ ';
	elsif (ds_fyb_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Fyb- ';
	end if;
	if (ds_jka_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Jka+ ';
	elsif (ds_jka_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Jka- ';
	end if;
	if (ds_jkb_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Jkb+ ';
	elsif (ds_jkb_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Jkb- ';
	end if;
	if (ds_lea_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Lea+ ';
	elsif (ds_lea_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Lea- ';
	end if;
	if (ds_leb_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Leb+ ';
	elsif (ds_leb_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Leb- ';
	end if;
	if (ds_p1_w = '1') then
		ds_retorno_w := ds_retorno_w ||'P1+ ';
	elsif (ds_p1_w = '0') then
		ds_retorno_w := ds_retorno_w ||'P1- ';
	end if;
	if (ds_m_w = '1') then
		ds_retorno_w := ds_retorno_w ||'M+ ';
	elsif (ds_m_w = '0') then
		ds_retorno_w := ds_retorno_w ||'M- ';
	end if;
	if (ds_n_w = '1') then
		ds_retorno_w := ds_retorno_w ||'N+ ';
	elsif (ds_n_w = '0') then
		ds_retorno_w := ds_retorno_w ||'N- ';
	end if;
	if (ds_s_w = '1') then
		ds_retorno_w := ds_retorno_w ||'S+ ';
	elsif (ds_s_w = '0') then
		ds_retorno_w := ds_retorno_w ||'S- ';
	end if;
	if (ds_s_min_w = '1') then
		ds_retorno_w := ds_retorno_w ||'s+ ';
	elsif (ds_s_min_w = '0') then
		ds_retorno_w := ds_retorno_w ||'s- ';
	end if;
	if (ds_lua_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Lua+ ';
	elsif (ds_lua_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Lua- ';
	end if;
	if (ds_lub_w = '1') then
		ds_retorno_w := ds_retorno_w ||'Lub+ ';
	elsif (ds_lub_w = '0') then
		ds_retorno_w := ds_retorno_w ||'Lub- ';
	end if;
	if (ds_dia_w = '1') then
		ds_retorno_w := ds_retorno_w ||'DIA+ ';
	elsif (ds_dia_w = '0') then
		ds_retorno_w := ds_retorno_w ||'DIA- ';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_ds_fenotipagem (nr_sequencia_p bigint) FROM PUBLIC;

