-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_impedimto_triagem (nr_seq_doacao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ds_auxiliar1_w	smallint;
ds_auxiliar2_w	varchar(2);

BEGIN

if (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') then

	ds_retorno_w := 'A';
	SELECT	count(*)
	INTO STRICT	ds_auxiliar1_w
	FROM 	san_doacao
	WHERE	nr_sequencia = nr_seq_doacao_p
	AND	(nr_motivo_desistencia IS NOT NULL AND nr_motivo_desistencia::text <> '')
	AND 	ds_local_desistencia = 'TR';

	if (ds_auxiliar1_w = 0) then
		ds_auxiliar2_w := san_verifica_doador_inapto( nr_seq_doacao_p,wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario);
		if (ds_auxiliar2_w <> 'A') then
			ds_retorno_w := 'I';
		end if;
	else
		ds_retorno_w := 'I';
	end if;
end if;
RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_impedimto_triagem (nr_seq_doacao_p bigint) FROM PUBLIC;

