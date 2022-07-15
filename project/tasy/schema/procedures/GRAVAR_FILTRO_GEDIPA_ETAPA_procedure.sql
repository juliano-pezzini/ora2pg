-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_filtro_gedipa_etapa ( nm_usuario_p text, nr_seq_agrup_classif_p bigint, cd_local_estoque_p bigint, nr_seq_area_prep_p bigint, cd_estabelecimento_p bigint, cd_profissional_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_etapa_p INOUT bigint) AS $body$
DECLARE

					
nr_seq_etapa_w 			bigint;
ie_higienizacao_w		adep_area_prep.ie_higienizacao%type;	
ie_processo_separado_w	adep_area_prep.ie_separacao%type;	


BEGIN

select nextval('gedipa_etapa_producao_seq')
into STRICT nr_seq_etapa_w
;

insert into gedipa_etapa_producao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_etapa,
		ie_status_etapa,
		cd_profissional,
		cd_estabelecimento,
		nr_seq_agrup_classif,
		cd_local_estoque,
		nr_seq_area_prep,
		dt_inicial,
		dt_final)
	values (
		nr_seq_etapa_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		'G',
		cd_profissional_p,
		cd_estabelecimento_p,
		nr_seq_agrup_classif_p,
		cd_local_estoque_p,
		nr_seq_area_prep_p,
		dt_inicial_p,
		dt_final_p);

	nr_seq_etapa_p := nr_seq_etapa_w;
	
	commit;

	if (nr_seq_area_prep_p > 0) then
	
		select	coalesce(max(ie_higienizacao),'S'),
				coalesce(max(ie_separacao),'S')
		into STRICT	ie_higienizacao_w,
				ie_processo_separado_w
		from	adep_area_prep
		where	nr_sequencia = nr_seq_area_prep_p;
		
		if (ie_processo_separado_w = 'N') then
			CALL gedipa_separar_etapa(nr_seq_etapa_w, nm_usuario_p);
			
			
			if (ie_higienizacao_w = 'N') then
				CALL gedipa_higienizar_etapa(nr_seq_etapa_w, nm_usuario_p);		
			end if;
			
		end if;		
	
	end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_filtro_gedipa_etapa ( nm_usuario_p text, nr_seq_agrup_classif_p bigint, cd_local_estoque_p bigint, nr_seq_area_prep_p bigint, cd_estabelecimento_p bigint, cd_profissional_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_etapa_p INOUT bigint) FROM PUBLIC;

