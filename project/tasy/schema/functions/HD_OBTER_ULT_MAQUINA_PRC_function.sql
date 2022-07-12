-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_ult_maquina_prc ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


dt_viagem_w			timestamp;
nr_seq_dialise_w		bigint;
nr_seq_dialise_dialisador_w	bigint;
nr_seq_maquina_w		bigint;

ds_retorno_w		varchar(80);



BEGIN

select	dt_inicio
into STRICT	dt_viagem_w
from	hd_escala_dialise
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	coalesce(dt_fim::text, '') = '';


select	max(nr_sequencia)
into STRICT	nr_seq_dialise_w
from	hd_dialise
where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
and	dt_inicio_dialise	<= dt_viagem_w;


select	max(nr_sequencia)
into STRICT	nr_seq_dialise_dialisador_w
from	hd_dialise_dialisador
where	nr_seq_dialise		= nr_seq_dialise_w;

select	nr_seq_maquina
into STRICT	nr_seq_maquina_w
from	hd_dialise_dialisador
where	nr_sequencia		= nr_seq_dialise_dialisador_w;


select	cd_maquina || ' - ' || ds_maquina_dialise
into STRICT	ds_retorno_w
from    hd_maquina_dialise
where   nr_sequencia		= nr_seq_maquina_w;


return	ds_retorno_w;


End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_ult_maquina_prc ( cd_pessoa_fisica_p text) FROM PUBLIC;
