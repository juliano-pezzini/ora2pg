-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cons_atend_sem_alta_regra_js ( nr_atendimento_atual_p bigint, ie_tipo_atend_atual_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, cd_setor_atual_p bigint, ie_tipo_atend_tiss_atual_p text, ds_consistencia_p INOUT text, ie_clinica_atual_p text, qt_regra_p INOUT bigint, ie_tipo_convenio_atual_p text default null) AS $body$
DECLARE

ds_consistencia_w	varchar(255);
					

BEGIN

ds_consistencia_w := consistir_atend_sem_alta(nr_atendimento_atual_p, ie_tipo_atend_atual_p, cd_pessoa_fisica_p, cd_estabelecimento_p, cd_setor_atual_p, ie_tipo_atend_tiss_atual_p, ie_clinica_atual_p, ds_consistencia_w, ie_tipo_convenio_atual_p);

ds_consistencia_p := ds_consistencia_w;

select 	count(*)
into STRICT	qt_regra_p
from 	regra_atend_sem_alta 
where 	(cd_setor_anterior IS NOT NULL AND cd_setor_anterior::text <> '');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cons_atend_sem_alta_regra_js ( nr_atendimento_atual_p bigint, ie_tipo_atend_atual_p bigint, cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, cd_setor_atual_p bigint, ie_tipo_atend_tiss_atual_p text, ds_consistencia_p INOUT text, ie_clinica_atual_p text, qt_regra_p INOUT bigint, ie_tipo_convenio_atual_p text default null) FROM PUBLIC;
