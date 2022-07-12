-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dias_compl_guia ( dt_liberacao_p timestamp) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Obter quantidade de dias na regra para o complemento da guia no portal
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/dt_dia_final_w		integer;
qt_mes_w		integer;
qt_retorno_w		varchar(10);
dia_atual_w		varchar(2);
mes_atual_w		varchar(2);
qt_dias_mes_w		integer;


BEGIN
if (pls_obter_se_controle_estab('RE') = 'S') then
	select	coalesce(max(qt_mes_complemento), 0),
		coalesce(max(dt_dia_complemento), 0)
	into STRICT	qt_mes_w,
		dt_dia_final_w
	from	pls_regra_compl_guia_web
	where	ie_situacao = 'A'
	and 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento;
else
	select	coalesce(max(qt_mes_complemento), 0),
		coalesce(max(dt_dia_complemento), 0)
	into STRICT	qt_mes_w,
		dt_dia_final_w
	from	pls_regra_compl_guia_web
	where	ie_situacao = 'A';
end if;

select 	to_char(clock_timestamp(), 'dd'),
	to_char(clock_timestamp(), 'mm')
into STRICT	dia_atual_w,
	mes_atual_w
;


if (qt_mes_w > 0 and dt_dia_final_w > 0) then

	qt_dias_mes_w := obter_qt_dias_mes(clock_timestamp());
	if (dt_dia_final_w >  qt_dias_mes_w) then
		dt_dia_final_w := qt_dias_mes_w;
	end if;

	if ((dia_atual_w)::numeric  > dt_dia_final_w) then
		qt_retorno_w  := trunc(to_date(dt_dia_final_w||'/'||to_char(add_months(clock_timestamp(), +1), 'mm/yyyy')) - clock_timestamp());
	else
		qt_retorno_w  := trunc(to_date(dt_dia_final_w||'/'||to_char(clock_timestamp(), 'mm/yyyy')) - clock_timestamp());
	end if;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dias_compl_guia ( dt_liberacao_p timestamp) FROM PUBLIC;

