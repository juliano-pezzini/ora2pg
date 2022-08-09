-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_futuro_change_js ( ie_asa_estado_paciente_p text, nr_atend_origem_p bigint, cd_medico_p bigint, ds_status_asa_pac_p INOUT bigint, ds_texto_p INOUT text, cd_pessoa_fisica_p INOUT bigint, nr_crm_p INOUT text) AS $body$
DECLARE


ds_status_asa_pac_w	bigint;
ds_texto_w		varchar(100);
cd_pessoa_fisica_w	bigint;
nr_crm_w		varchar(25);


BEGIN

select	coalesce(max(nr_seq_status),0)
into STRICT	ds_status_asa_pac_w
from	regra_status_atend_futuro
where 	ie_asa_estado_paciente = ie_asa_estado_paciente_p;

ds_texto_w	:= obter_texto_tasy(61584, wheb_usuario_pck.get_nr_seq_idioma);

select 	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from 	atendimento_paciente
where 	nr_atendimento = nr_atend_origem_p;

select 	coalesce(max(substr(obter_crm_medico(cd_pessoa_fisica), 1, 255)),null)
into STRICT	nr_crm_w
from 	medico
where 	cd_pessoa_fisica = cd_medico_p;

ds_status_asa_pac_p	:= ds_status_asa_pac_w;
ds_texto_p		:= ds_texto_w;
cd_pessoa_fisica_p	:= cd_pessoa_fisica_w;
nr_crm_p		:= nr_crm_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_futuro_change_js ( ie_asa_estado_paciente_p text, nr_atend_origem_p bigint, cd_medico_p bigint, ds_status_asa_pac_p INOUT bigint, ds_texto_p INOUT text, cd_pessoa_fisica_p INOUT bigint, nr_crm_p INOUT text) FROM PUBLIC;
