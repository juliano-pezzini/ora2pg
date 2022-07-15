-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alteracao_pool ( nr_prescricao_p bigint, nr_sequencia_p bigint, qt_pool_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
nr_prescricao_w		prescr_medica.nr_prescricao%type;
nr_seq_proc_w		prescr_procedimento.nr_sequencia%type;


BEGIN 
 
if (coalesce(nr_prescricao_p::text, '') = '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then 
 
	select	max(nr_prescricao), 
			max(nr_seq_procedimento) 
	into STRICT	nr_prescricao_w, 
			nr_seq_proc_w 
	from	prescr_proc_hor 
	where	nr_sequencia = nr_sequencia_p;	
 
else 
	nr_prescricao_w	:= nr_prescricao_p;
	nr_seq_proc_w	:= nr_sequencia_p;
end if;
 
if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') and (nr_seq_proc_w IS NOT NULL AND nr_seq_proc_w::text <> '') then 
	 
	update 	prescr_procedimento 
	set		qt_etapa = qt_pool_p, 
			nm_usuario = nm_usuario_p 
	where	nr_prescricao = nr_prescricao_w 
	and		nr_sequencia = nr_seq_proc_w;
	 
	select	nextval('prescr_solucao_evento_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert into prescr_solucao_evento( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_prescricao, 
		nr_seq_solucao, 
		nr_seq_material, 
		nr_seq_procedimento, 
		nr_seq_nut, 
		nr_seq_nut_neo, 
		ie_forma_infusao, 
		ie_tipo_dosagem, 
		qt_dosagem, 
		qt_vol_infundido, 
		qt_vol_desprezado, 
		cd_pessoa_fisica, 
		ie_alteracao, 
		dt_alteracao, 
		ie_evento_valido, 
		nr_seq_motivo, 
		ds_observacao, 
		ie_tipo_solucao, 
		dt_aprazamento) 
	values ( 
		nr_sequencia_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_prescricao_w, 
		null, 
		null, 
		nr_seq_proc_w, 
		null, 
		null, 
		null, 
		null, 
		null, 
		null, 
		null, 
		obter_dados_usuario_opcao(nm_usuario_p, 'C'), 
		18, 
		clock_timestamp(), 
		'S', 
		null, 
		null, 
		3, 
		clock_timestamp());
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alteracao_pool ( nr_prescricao_p bigint, nr_sequencia_p bigint, qt_pool_p bigint, nm_usuario_p text) FROM PUBLIC;

