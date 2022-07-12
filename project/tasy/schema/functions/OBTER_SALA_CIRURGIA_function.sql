-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sala_cirurgia ( CD_CIRURGIA_P bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(50);
nr_atendimento_w	bigint;
dt_entrada_unidade_w	timestamp;



BEGIN

Select	nr_atendimento,
	dt_entrada_unidade
into STRICT	nr_atendimento_w,
	dt_entrada_unidade_w
from	cirurgia
where	nr_cirurgia	= CD_CIRURGIA_P;


Select	cd_unidade_basica
into STRICT	ds_retorno_w
from	atend_paciente_unidade
where	nr_atendimento		= nr_atendimento_w
and	dt_entrada_unidade	= dt_entrada_unidade_w;


return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sala_cirurgia ( CD_CIRURGIA_P bigint) FROM PUBLIC;

