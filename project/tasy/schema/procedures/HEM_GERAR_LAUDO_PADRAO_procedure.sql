-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_gerar_laudo_padrao ( nr_seq_proc_p bigint, nr_seq_laudo_padrao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_laudo_w			bigint;
nr_seq_coron_w			bigint;
nr_seq_vaso_w			bigint;
nr_seq_importancia_w		bigint;
pr_obstrucao_w			numeric(20);
nr_seq_tipo_lesao_w		bigint;
nr_seq_coron_localizacao_w	                bigint;
nr_seq_segmento_w		bigint;
					
C01 CURSOR FOR
SELECT	nextval('hem_coronariografia_seq'),
	nr_seq_vaso,
	nr_seq_importancia,
	pr_obstrucao,
	nr_seq_tipo_lesao,
	nextval('hem_coron_localizacao_seq'),
	nr_seq_segmento
from	hem_padrao_coronariografia
where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
and	coalesce(ie_situacao,'A') = 'A';
					

BEGIN

if	((coalesce(nr_seq_proc_p,0) > 0) and (coalesce(nr_seq_laudo_padrao_p,0) > 0)) then
		
		delete	FROM hem_laudo
		where	nr_seq_proc = nr_seq_proc_p;
		
		delete	FROM hem_observacao_laudo
		where	nr_seq_proc = nr_seq_proc_p;

		delete FROM hem_circulacao_colateral
		where  nr_seq_proc = nr_seq_proc_p;

		delete FROM hem_manometria_completa
		where  nr_seq_proc = nr_seq_proc_p;

		delete FROM hem_coronariografia
		where  nr_seq_proc = nr_seq_proc_p;
		
		select	nextval('hem_laudo_seq')
		into STRICT	nr_seq_laudo_w
		;
		
		insert into hem_laudo(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_registro,
			nr_seq_proc
		) (
			SELECT	nr_seq_laudo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_proc_p
			from	hem_padrao_laudo
			where	nr_sequencia = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A'
			);
		
		insert into hem_manometria_completa(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_tipo,
			qt_pam,
			qt_pa_diastolica_fim,
			qt_pa_diastolica_ini,
			qt_pa_sistolica,
			nr_seq_laudo,
			nr_seq_proc
		) (
			SELECT	nextval('hem_manometria_completa_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				ie_tipo_camera,
				qt_pam,
				qt_pa_diastolica_fim,
				qt_pa_diastolica_ini,
				qt_pa_sistolica,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_manometria
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');
			
		insert into hem_analise_manometria(
			nr_sequencia,
			dt_atualizacao,         
			nm_usuario,            
			dt_atualizacao_nrec,
			nm_usuario_nrec,        
			nr_seq_analise,         
			nr_seq_laudo,           
			nr_seq_proc
		) (
			SELECT	nextval('hem_analise_manometria_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_analise,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_analise_manomet
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');
			
		open C01;
		loop
		fetch C01 into	nr_seq_coron_w,
			nr_seq_vaso_w,
			nr_seq_importancia_w,
			pr_obstrucao_w,
			nr_seq_tipo_lesao_w,
			nr_seq_coron_localizacao_w,
			nr_seq_segmento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			insert into hem_coronariografia(
				nr_sequencia,
				dt_atualizacao,         
				nm_usuario,            
				dt_atualizacao_nrec,
				nm_usuario_nrec,        
				nr_seq_vaso,    
				nr_seq_importancia,  
				pr_obstrucao,
				nr_seq_tipo_lesao,
				nr_seq_laudo,           
				nr_seq_proc
			) values (
				nr_seq_coron_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_vaso_w,
				nr_seq_importancia_w, 
				pr_obstrucao_W,
				nr_seq_tipo_lesao_w,
				nr_seq_laudo_w,
				nr_seq_proc_p
			);

			if (nr_seq_segmento_w IS NOT NULL AND nr_seq_segmento_w::text <> '') then
				insert into hem_coron_localizacao(
					nr_sequencia,           
					dt_atualizacao,         
					nm_usuario,            
					dt_atualizacao_nrec,
					nm_usuario_nrec,        
					nr_seq_coron,
					nr_seq_segmento
				) values (
					nr_seq_coron_localizacao_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_coron_w,
					nr_seq_segmento_w
				);
			end if;

			end;
		end loop;
		close C01;
			
		insert into hem_ventriculografia_proc(
			nr_sequencia,           
			dt_atualizacao,         
			nm_usuario,            
			dt_atualizacao_nrec,
			nm_usuario_nrec,        
			nr_seq_ventric_ve,
			nr_seq_ventric_vd,
			nr_seq_laudo,           
			nr_seq_proc
		) (
			SELECT	nextval('hem_ventriculografia_proc_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,      
				nr_seq_ventric_ve,
				nr_seq_ventric_vd,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_ventric_proc
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');
			
		insert into hem_cineangiocard_proc(
			nr_sequencia,
			dt_atualizacao,         
			nm_usuario,            
			dt_atualizacao_nrec,
			nm_usuario_nrec,      
			nr_seq_cineangioc,
			nr_seq_laudo,           
			nr_seq_proc
		) (
			SELECT	nextval('hem_cineangiocard_proc_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,      
				nr_seq_cineangioc,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_cinean_proc
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');
			
		insert into hem_circulacao_colateral(
			nr_sequencia,
			dt_atualizacao,         
			nm_usuario,            
			dt_atualizacao_nrec,
			nm_usuario_nrec,      
			ie_circulacao_col,
			nr_seq_fonte_dir,
			nr_seq_intensidade,
			nr_seq_laudo,           
			nr_seq_proc
		) (
			SELECT	nextval('hem_circulacao_colateral_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,        
				ie_circulacao_col,
				nr_seq_fonte_dir,
				nr_seq_intensidade,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_circ_colateral
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');
			
		insert into hem_conclusao_coron(
			nr_sequencia,
			dt_atualizacao,         
			nm_usuario,            
			dt_atualizacao_nrec,
			nm_usuario_nrec,      
			nr_seq_coronaria,
			nr_seq_inf_adic,
			ds_observacao_laudo,
			nr_seq_laudo,           
			nr_seq_proc
		) (
			SELECT	nextval('hem_conclusao_coron_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,        
				nr_seq_coronaria,
				nr_seq_inf_adic,
				ds_observacao_laudo,
				nr_seq_laudo_w,
				nr_seq_proc_p
			from	hem_padrao_conclusao_coron
			where	nr_seq_laudo_padrao = nr_seq_laudo_padrao_p
			and	coalesce(ie_situacao,'A') = 'A');

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_gerar_laudo_padrao ( nr_seq_proc_p bigint, nr_seq_laudo_padrao_p bigint, nm_usuario_p text) FROM PUBLIC;

