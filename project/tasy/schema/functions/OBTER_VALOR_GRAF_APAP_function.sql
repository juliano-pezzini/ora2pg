-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_graf_apap ( dt_hora_p timestamp, nr_seq_inf_p bigint, cd_exp_p bigint, nr_atendimento_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_hora_w		bigint;
ds_informacao_w	varchar(255);


BEGIN

if (coalesce(nr_seq_inf_p,0) > 0) then
	select	substr(obter_desc_expressao(cd_exp_informacao),1,255)
	into STRICT	ds_informacao_w
	from	pep_informacao
	where	nr_sequencia = nr_seq_inf_p;
else
	select	substr(obter_desc_expressao(cd_exp_p),1,255)
	into STRICT	ds_informacao_w
	;
end if;

Select  max(qt_hora)
into STRICT	qt_hora_w
from	w_pep_apap_grafico
where	nr_atendimento_p = nr_atendimento_p
and		nm_usuario = nm_usuario_p
and		trim(both ds_informacao) = ds_informacao_w
and		dt_hora = dt_hora_p;

return qt_hora_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_graf_apap ( dt_hora_p timestamp, nr_seq_inf_p bigint, cd_exp_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

