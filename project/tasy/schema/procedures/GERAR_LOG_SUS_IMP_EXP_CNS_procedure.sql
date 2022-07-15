-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_log_sus_imp_exp_cns ( cd_pessoa_fisica_p text , ds_status_p text , ie_tipo_operacao_p text , nm_usuario_p text, SG_UF_EMISSOR_P text, CPF_P text) AS $body$
DECLARE



ds_maq_user_w 			varchar(100);
cd_pessoa_fisica_w			varchar(16);
ie_existe_w				bigint;
ds_status_w				varchar(255);


BEGIN

select	substr(obter_inf_sessao(0),1,100)
into STRICT	ds_maq_user_w
;

select	coalesce(max(cd_pessoa_fisica),0)
into STRICT	cd_pessoa_fisica_w
from	pessoa_fisica
where	nr_cpf = CPF_P;

if (coalesce(cd_pessoa_fisica_w,0) = 0) then
		ds_status_w := wheb_mensagem_pck.get_texto(803022) || ' ';
elsif (cd_pessoa_fisica_w > 0 and
		coalesce(sg_uf_emissor_p,'X') <> 'X') then
			if (ie_tipo_operacao_p = 'I') then
				ds_status_w := wheb_mensagem_pck.get_texto(803024) || ' ';
			else
				ds_status_w := wheb_mensagem_pck.get_texto(803025) || ' ';
			end if;
end if;

if (coalesce(sg_uf_emissor_p,'X') = 'X') then
	if (coalesce(cd_pessoa_fisica_w,0) = 0) then
		ds_status_w := ds_status_w|| wheb_mensagem_pck.get_texto(803028) || ' ';
	else
		ds_status_w := wheb_mensagem_pck.get_texto(803028) || ' ';
	end if;
end if;

cd_pessoa_fisica_w	:= somente_numero(cd_pessoa_fisica_p);

insert into sus_log_imp_exp_cns(	cd_pessoa_fisica,
					ds_maquina,
					ds_status,
					dt_atualizacao,
					ie_tipo_operacao,
					nm_usuario,
					nr_sequencia)
				values (	cd_pessoa_fisica_w,
					ds_maq_user_w,
					ds_status_w,
					clock_timestamp(),
					ie_tipo_operacao_p,
					nm_usuario_p,
					nextval('sus_log_imp_exp_cns_seq'));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_log_sus_imp_exp_cns ( cd_pessoa_fisica_p text , ds_status_p text , ie_tipo_operacao_p text , nm_usuario_p text, SG_UF_EMISSOR_P text, CPF_P text) FROM PUBLIC;

