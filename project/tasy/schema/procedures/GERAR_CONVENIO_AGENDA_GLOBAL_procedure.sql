-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_convenio_agenda_global (cd_pessoa_fisica_p text, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_forma_convenio_p text, nm_usuario_p text) AS $body$
DECLARE

 
cd_convenio_w			integer;
cd_categoria_w		varchar(10);
cd_usuario_convenio_w	varchar(30);
dt_validade_w			timestamp;
nr_doc_convenio_w		varchar(20);
cd_tipo_acomodacao_w		smallint;
cd_plano_w			varchar(10);
ds_observacao_w		varchar(4000);


BEGIN 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_tipo_agenda_p IS NOT NULL AND cd_tipo_agenda_p::text <> '') and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '') and (ie_forma_convenio_p IS NOT NULL AND ie_forma_convenio_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	/* obter dados convenio */
 
	SELECT * FROM gerar_convenio_agendamento(cd_pessoa_fisica_p, cd_tipo_agenda_p, nr_seq_agenda_p, ie_forma_convenio_p, cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, nm_usuario_p, ds_observacao_w) INTO STRICT cd_convenio_w, cd_categoria_w, cd_usuario_convenio_w, dt_validade_w, nr_doc_convenio_w, cd_tipo_acomodacao_w, cd_plano_w, ds_observacao_w;
 
	/* gerar dados convenio */
 
	if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then 
		update	agenda_paciente 
		set	cd_convenio		= cd_convenio_w, 
			cd_categoria		= cd_categoria_w, 
			cd_usuario_convenio	= cd_usuario_convenio_w, 
			dt_validade_carteira	= dt_validade_w, 
			nr_doc_convenio	= nr_doc_convenio_w, 
			cd_tipo_acomodacao	= cd_tipo_acomodacao_w, 
			cd_plano		= cd_plano_w, 
			ds_observacao 	= ds_observacao_w 
		where	nr_sequencia		= nr_seq_agenda_p;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_convenio_agenda_global (cd_pessoa_fisica_p text, cd_tipo_agenda_p bigint, nr_seq_agenda_p bigint, ie_forma_convenio_p text, nm_usuario_p text) FROM PUBLIC;

