-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_doacao_vencida (nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


dt_inicio_coleta_w	timestamp;
qt_validade_solic_reserva_w	bigint;
dt_validade_final_w	timestamp;
ds_retorno_w		varchar(1) := 'N';


BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	select	max(coalesce(qt_validade_solic_reserva, 0))
	into STRICT	qt_validade_solic_reserva_w
	from	san_parametro
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

	select	max(dt_inicio_coleta)
	into STRICT	dt_inicio_coleta_w
	from	san_doacao
	where	nr_sequencia = nr_seq_doacao_p;

	if (dt_inicio_coleta_w IS NOT NULL AND dt_inicio_coleta_w::text <> '') then

		dt_validade_final_w := dt_inicio_coleta_w + (qt_validade_solic_reserva_w/24);

		if (dt_validade_final_w < clock_timestamp()) then
			ds_retorno_w := 'S';
		end if;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_doacao_vencida (nr_seq_doacao_p bigint) FROM PUBLIC;
