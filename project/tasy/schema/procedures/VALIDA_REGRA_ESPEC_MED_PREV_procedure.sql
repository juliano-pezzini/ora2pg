-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_regra_espec_med_prev ( CD_ESPEC_MEDICO_RESP_P bigint, IE_TIPO_ATENDIMENTO_P bigint, IE_TIPO_CONVENIO_P bigint, CD_CONVENIO_P bigint, CD_PESSOA_FISICA_P text, DS_MENSAGEM_P out text, IE_PERMITE_P out text ) is ds_mensagem_w varchar(4000) AS $body$
DECLARE

ds_motivo_w	motivo_bloqueio_campanha.ds_motivo%type;
BEGIN
	select 	ds_motivo
	into STRICT 	ds_motivo_w
	from 	MOTIVO_BLOQUEIO_CAMPANHA
	where 	nr_sequencia = nr_seq_bloq;
	
	return;
end;

begin


for c01_r in c01 --regra especifica para o participante
loop
	ie_permite_w := c01_r.ie_permite;
	if ( ie_permite_w = 'S') then
		ds_mensagem_w := '';

		exit;
	end if;

	ds_mensagem_w := coalesce(obter_mensagem_especialidade( c01_r.cd_especialidade, 'B'),
		replace(obter_Desc_expressao(1023401), '#@DS_ESPECIALIDADE#@', OBTER_DESC_ESPEC_MEDICA( c01_r.cd_especialidade)));
	if (c01_r.nr_seq_motivo IS NOT NULL AND c01_r.nr_seq_motivo::text <> '') then
		ds_mensagem_w := substr(ds_mensagem_w || chr(13) || chr(10) || obter_motivo_bloqueio(c01_r.nr_seq_motivo), 1 ,4000);
	end if;
end loop;


if (coalesce(ie_permite_w::text, '') = '') then -- se o paciente nao tem bloqueio ou liberacao especifica para ele, verificar se ha regra por campanha
	for c02_r in C02 -- regra para a campanha que o participante esta
	loop
		ie_permite_w := c02_r.ie_permite;
		if ( ie_permite_w = 'S') then

			ds_mensagem_w := '';
			exit;
		end if;

		ds_mensagem_w := coalesce(obter_mensagem_especialidade( c02_r.cd_especialidade, 'B'),
			replace(obter_Desc_expressao(1023401), '#@DS_ESPECIALIDADE#@', OBTER_DESC_ESPEC_MEDICA( c02_r.cd_especialidade)));
			
		if (c02_r.nr_seq_motivo IS NOT NULL AND c02_r.nr_seq_motivo::text <> '') then
			ds_mensagem_w := substr(ds_mensagem_w || chr(13) || chr(10) || obter_motivo_bloqueio( c02_r.nr_seq_motivo), 1 ,4000);
		end if;
	end loop;
end if;

DS_MENSAGEM_P :=	substr(ds_mensagem_w,1,4000);
IE_PERMITE_P := coalesce(ie_permite_w, 'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_regra_espec_med_prev ( CD_ESPEC_MEDICO_RESP_P bigint, IE_TIPO_ATENDIMENTO_P bigint, IE_TIPO_CONVENIO_P bigint, CD_CONVENIO_P bigint, CD_PESSOA_FISICA_P text, DS_MENSAGEM_P out text, IE_PERMITE_P out text ) is ds_mensagem_w varchar(4000) FROM PUBLIC;

