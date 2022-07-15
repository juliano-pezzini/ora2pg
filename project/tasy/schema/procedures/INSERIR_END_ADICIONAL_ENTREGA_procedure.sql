-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_end_adicional_entrega ( ds_lista_p text, nm_usuario_p text, ds_endereco_p text, cd_cep_p text, nr_endereco_p bigint, ds_complemento_p text, ds_bairro_p text, ds_municipio_p text, sg_estado_p text, nr_telefone_p text, nr_ramal_p bigint, ds_observacao_p text, ds_email_p text, cd_municipio_ibge_p text, ds_fone_adic_p text, ds_fax_p text, cd_tipo_logradouro_p text, nr_ddd_telefone_p text, nr_ddi_telefone_p text, nr_ddi_fax_p text, nr_ddd_fax_p text, nr_ddi_fone_adic_p text default null, nr_seq_forma_laudo_p bigint DEFAULT NULL) AS $body$
DECLARE


ds_lista_w		varchar(4000);
tam_lista_w		bigint;
ie_pos_virgula_w	smallint;
nr_prescricao_w		bigint;
nr_seq_prescr_entrega_w	bigint;
nr_seq_end_adic_prescr_w	bigint;
qt_municipio_ibge_w	bigint;



BEGIN

ds_lista_w := ds_lista_p;

select	count(*)
into STRICT	qt_municipio_ibge_w
from	sus_municipio
where	cd_municipio_ibge = cd_municipio_ibge_p;

if (qt_municipio_ibge_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(349401);
end if;

while(ds_lista_w IS NOT NULL AND ds_lista_w::text <> '')  loop
	begin
	tam_lista_w		:= length(ds_lista_w);
	ie_pos_virgula_w		:= position(',' in ds_lista_w);

	if (ie_pos_virgula_w <> 0) then
		nr_prescricao_w	:= (substr(ds_lista_w,1,(ie_pos_virgula_w - 1)))::numeric;
		ds_lista_w		:= substr(ds_lista_w,(ie_pos_virgula_w + 1),tam_lista_w);
	end if;


	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_end_adic_prescr_w
	from	prescr_medica_entrega
	where	nr_prescricao = nr_prescricao_w;

	if (nr_seq_end_adic_prescr_w > 0) then

		update	prescr_medica_entrega
		set	ds_endereco = substr(ds_endereco_p,1,40),
			cd_cep = substr(cd_cep_p,1,15),
			nr_endereco =  nr_endereco_p,
			ds_complemento =  substr(ds_complemento_p,1,40),
			ds_bairro = substr(ds_bairro_p,1,40),
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			ds_municipio = substr(ds_municipio_p,1,40),
			sg_estado = substr(sg_estado_p,1,15),
			nr_telefone = substr(nr_telefone_p,1,15),
			nr_ramal = nr_ramal_p,
			ds_observacao = substr(ds_observacao_p,1,2000),
			ds_email = substr(ds_email_p,1,255),
			nr_prescricao = nr_prescricao_w,
			cd_municipio_ibge = substr(cd_municipio_ibge_p,1,6),
			ds_fone_adic = substr(ds_fone_adic_p,1,80),
			ds_fax = substr(ds_fax_p,1,80),
			cd_tipo_logradouro = substr(cd_tipo_logradouro_p,1,3),
			nr_ddd_telefone = substr(nr_ddd_telefone_p,1,3),
			nr_ddi_telefone = substr(nr_ddi_telefone_p,1,3),
			nr_ddi_fax = substr(nr_ddi_fax_p,1,3),
			nr_ddd_fax = substr(nr_ddd_fax_p,1,3),
			nr_ddi_fone_dic = substr(nr_ddi_fone_adic_p,1,3)
		where	nr_sequencia = nr_seq_end_adic_prescr_w;

		update	prescr_medica
		set	nr_seq_forma_laudo = nr_seq_forma_laudo_p
		where	nr_prescricao = nr_prescricao_w;

	else

		select	nextval('prescr_medica_entrega_seq')
		into STRICT	nr_seq_prescr_entrega_w
		;

		insert into prescr_medica_entrega(
					nr_sequencia,
					ds_endereco,
					cd_cep,
					nr_endereco,
					ds_complemento,
					ds_bairro,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
					ds_municipio,
					sg_estado,
					nr_telefone,
					nr_ramal,
					ds_observacao,
					ds_email,
					nr_prescricao,
					cd_municipio_ibge,
					ds_fone_adic,
					ds_fax,
					cd_tipo_logradouro,
					nr_ddd_telefone,
					nr_ddi_telefone,
					nr_ddi_fax,
					nr_ddd_fax,
					nr_ddi_fone_dic
					)
				values (
					nr_seq_prescr_entrega_w,
					substr(ds_endereco_p,1,40),
					substr(cd_cep_p,1,15),
					nr_endereco_p,
					substr(ds_complemento_p,1,40),
					substr(ds_bairro_p,1,40),
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_P,
					substr(ds_municipio_p,1,40),
					substr(sg_estado_p,1,15),
					substr(nr_telefone_p,1,15),
					nr_ramal_p,
					substr(ds_observacao_p,1,2000),
					substr(ds_email_p,1,255),
					nr_prescricao_w,
					substr(cd_municipio_ibge_p,1,6),
					substr(ds_fone_adic_p,1,80),
					substr(ds_fax_p,1,80),
					substr(cd_tipo_logradouro_p,1,3),
					substr(nr_ddd_telefone_p,1,3),
					substr(nr_ddi_telefone_p,1,3),
					substr(nr_ddi_fax_p,1,3),
					substr(nr_ddd_fax_p,1,3),
					substr(nr_ddi_fone_adic_p,1,3)
					);
		update	prescr_medica
		set	nr_seq_forma_laudo = nr_seq_forma_laudo_p
		where	nr_prescricao = nr_prescricao_w;

	end if;
	end;
	end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_end_adicional_entrega ( ds_lista_p text, nm_usuario_p text, ds_endereco_p text, cd_cep_p text, nr_endereco_p bigint, ds_complemento_p text, ds_bairro_p text, ds_municipio_p text, sg_estado_p text, nr_telefone_p text, nr_ramal_p bigint, ds_observacao_p text, ds_email_p text, cd_municipio_ibge_p text, ds_fone_adic_p text, ds_fax_p text, cd_tipo_logradouro_p text, nr_ddd_telefone_p text, nr_ddi_telefone_p text, nr_ddi_fax_p text, nr_ddd_fax_p text, nr_ddi_fone_adic_p text default null, nr_seq_forma_laudo_p bigint DEFAULT NULL) FROM PUBLIC;

