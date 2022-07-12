-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_receita_oftalmologia (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_tipo_lente_w 	varchar(80);
vl_od_pl_dio_esf_w 	real;
vl_od_pl_dio_cil_w 	real;
vl_od_pl_eixo_w 	real;
vl_od_pl_adicao_w 	real;
vl_oe_pl_dio_esf_w	real;
vl_oe_pl_dio_cil_w 	real;
vl_oe_pl_eixo_w 	real;
vl_oe_pl_adicao_w 	real;
vl_od_pp_dio_esf_w 	real;
vl_od_pp_dio_cil_w 	real;
vl_od_pp_eixo_w 	real;
vl_od_pp_adicao_w 	real;
vl_oe_pp_dio_esf_w 	real;
vl_oe_pp_dio_cil_w 	real;
vl_oe_pp_eixo_w 	real;
vl_oe_pp_adicao_w 	real;
ds_retorno_w		varchar(1000);
ds_result1 varchar(1000);
ds_result2 varchar(1000);
ds_result3 varchar(1000);
ds_result4 varchar(1000);
ds_result5 varchar(1000);

BEGIN
select	b.ds_tipo_lente,
	a.vl_od_pl_dio_esf,
	a.vl_od_pl_dio_cil,
	a.vl_od_pl_eixo,
	a.vl_od_pl_adicao,
	a.vl_oe_pl_dio_esf,
	a.vl_oe_pl_dio_cil,
	a.vl_oe_pl_eixo,
	a.vl_oe_pl_adicao,
	a.vl_od_pp_dio_esf,
	a.vl_od_pp_dio_cil,
	a.vl_od_pp_eixo,
	a.vl_od_pp_adicao,
	a.vl_oe_pp_dio_esf,
	a.vl_oe_pp_dio_cil,
	a.vl_oe_pp_eixo,
	a.vl_oe_pp_adicao
into STRICT	ds_tipo_lente_w,
	vl_od_pl_dio_esf_w,
	vl_od_pl_dio_cil_w,
	vl_od_pl_eixo_w,
	vl_od_pl_adicao_w,
	vl_oe_pl_dio_esf_w,
	vl_oe_pl_dio_cil_w,
	vl_oe_pl_eixo_w,
	vl_oe_pl_adicao_w,
	vl_od_pp_dio_esf_w,
	vl_od_pp_dio_cil_w,
	vl_od_pp_eixo_w,
	vl_od_pp_adicao_w,
	vl_oe_pp_dio_esf_w,
	vl_oe_pp_dio_cil_w,
	vl_oe_pp_eixo_w,
	vl_oe_pp_adicao_w
from	oft_tipo_lente b,
	oft_oculos a
where	a.nr_seq_tipo_lente = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;


if (ds_tipo_lente_w IS NOT NULL AND ds_tipo_lente_w::text <> '') then
	ds_result1 := wheb_mensagem_pck.get_texto(309263) || ': '||ds_tipo_lente_w ||'\par\par\par'; -- Tipo lente
end if;

ds_result2 := wheb_mensagem_pck.get_texto(309265) || ': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_od_pl_dio_esf_w),10,' '), '          ')  || wheb_mensagem_pck.get_texto(309266) ||': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_od_pl_dio_cil_w),10,' '), '          ') || wheb_mensagem_pck.get_texto(307523) || ': '|| coalesce(rpad(vl_od_pl_eixo_w,5,' '), '     ') ||wheb_mensagem_pck.get_texto(307185) || ': '||vl_od_pl_adicao_w|| '\par'; -- Para longe OD   DE	-- DC	-- Eixo	-- Adição
ds_result3 := '       ' || wheb_mensagem_pck.get_texto(355359) || ': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_oe_pl_dio_esf_w),10,' '), '          ')  || wheb_mensagem_pck.get_texto(309266) ||': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_oe_pl_dio_cil_w),10,' '), '          ') ||wheb_mensagem_pck.get_texto(307523) || ': '|| coalesce(rpad(vl_oe_pl_eixo_w,5,' '), '     ') ||wheb_mensagem_pck.get_texto(307185) || ': '||vl_oe_pl_adicao_w|| '\par\par\par\par'; --OD   DE	-- DC	-- Eixo	-- Adição
ds_result4 := wheb_mensagem_pck.get_texto(309272) || ': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_od_pp_dio_esf_w),10,' '), '          ')  || wheb_mensagem_pck.get_texto(309266) ||': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_od_pp_dio_cil_w),10,' '), '          ') ||wheb_mensagem_pck.get_texto(307523) || ': '|| coalesce(rpad(vl_od_pp_eixo_w,5,' '), '     ') ||wheb_mensagem_pck.get_texto(307185) || ': '||vl_od_pp_adicao_w|| '\par'; -- Para perto OD   DE	-- DC	-- Eixo	-- Adição
ds_result5 := '       ' || wheb_mensagem_pck.get_texto(355359) || ': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_oe_pp_dio_esf_w),10,' '), '          ')  || wheb_mensagem_pck.get_texto(309266) ||': '|| coalesce(rpad(oft_obter_valor_com_sinal(vl_oe_pp_dio_cil_w),10,' '), '          ') ||wheb_mensagem_pck.get_texto(307523) || ': '|| coalesce(rpad(vl_oe_pp_eixo_w,5,' '), '     ') ||wheb_mensagem_pck.get_texto(307185) || ': '||vl_oe_pp_adicao_w|| '\par'; -- OD   DE	-- DC	-- Eixo	-- Adição
ds_retorno_w := ds_result1 ||ds_result2 || ds_result3 || ds_result4 || ds_result5;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_receita_oftalmologia (nr_sequencia_p bigint) FROM PUBLIC;

