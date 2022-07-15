-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mmed_copiar_convenio_exame_lab ( nr_seq_lab_item_cp bigint, nr_seq_lab_item_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_lab_conv_item_w			ageint_exame_lab_conv_item.nr_sequencia%type;	
ie_tipo_atendimento_w			agenda_integrada.ie_tipo_atendimento%type;
cd_pessoa_fisica_w				pessoa_fisica.cd_pessoa_fisica%type;
dt_inicio_agendamento_w			timestamp;
nr_seq_agenda_integrada_w		agenda_integrada.nr_sequencia%type;
			

BEGIN 
 
if (nr_seq_lab_item_cp IS NOT NULL AND nr_seq_lab_item_cp::text <> '' AND nr_seq_lab_item_p IS NOT NULL AND nr_seq_lab_item_p::text <> '') then 
 
	select	nextval('ageint_exame_lab_conv_item_seq') 
	into STRICT	nr_seq_lab_conv_item_w 
	;
 
	insert into ageint_exame_lab_conv_item(dt_atualizacao_nrec, 
			dt_atualizacao, 
			nm_usuario,  
			nm_usuario_nrec, 
			cd_convenio, 
			cd_categoria, 
			cd_plano, 
			nr_doc_convenio, 
			cd_usuario_convenio, 
			dt_validade_carteira, 
			nr_sequencia, 
			nr_seq_lab_item) 
	SELECT 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p, 
			max(cd_convenio), 
			max(cd_categoria), 
			max(cd_plano), 
			max(nr_doc_convenio), 
			max(cd_usuario_convenio), 
			max(dt_validade_carteira), 
			nr_seq_lab_conv_item_w, 
			nr_seq_lab_item_p 
	from	ageint_exame_lab_conv_item 
	where	nr_seq_lab_item = nr_seq_lab_item_cp;
	 
	select	max(b.ie_tipo_atendimento), 
			max(b.cd_pessoa_fisica), 
			max(b.dt_inicio_agendamento), 
			max(b.nr_sequencia) 
	into STRICT	ie_tipo_atendimento_w, 
			cd_pessoa_fisica_w, 
			dt_inicio_agendamento_w, 
			nr_seq_agenda_integrada_w 
	from	ageint_exame_lab a, 
			agenda_integrada b	 
	where	a.nr_seq_ageint = b.nr_sequencia 
	and		a.nr_sequencia = nr_seq_lab_item_cp;
	 
	CALL calcular_valor_proc_lab_ageint(	nr_seq_agenda_integrada_w,null,null,obter_estabelecimento_ativo, 
									dt_inicio_agendamento_w,null, nm_usuario_p, 
									null,cd_pessoa_fisica_w,ie_tipo_atendimento_w, 
									nr_seq_lab_item_p, 'N');	
end if;	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mmed_copiar_convenio_exame_lab ( nr_seq_lab_item_cp bigint, nr_seq_lab_item_p bigint, nm_usuario_p text) FROM PUBLIC;

