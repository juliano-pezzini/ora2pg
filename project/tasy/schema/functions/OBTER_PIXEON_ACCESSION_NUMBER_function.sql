-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pixeon_accession_number ( nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


ds_accession_number_w	varchar(30);
cd_tipo_procedimento_w	bigint;


BEGIN

select campo_numerico(obter_tipo_procedimento(cd_procedimento_p, ie_origem_proced_p, 'C'))
into STRICT	cd_tipo_procedimento_w
;

ds_accession_number_w	:= 	to_char(cd_tipo_procedimento_w,'FM000') ||
					to_char(nr_prescricao_p,'FM00000000');
return	ds_accession_number_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pixeon_accession_number ( nr_prescricao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

