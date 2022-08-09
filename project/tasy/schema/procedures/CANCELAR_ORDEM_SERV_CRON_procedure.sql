-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_ordem_serv_cron ( nr_seq_proj_p bigint, nr_seq_motivo_cancel_p bigint, nr_seq_estagio_cancel_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_proj_cro_w 	bigint;			
nr_seq_cro_eta_w 	bigint;
nr_seq_os_w 		bigint;
ds_his_w			text;
			
c01 CURSOR FOR  --seleciona todos os cronogramas conforme o projeto 
	SELECT	e.nr_sequencia nr_seq_cronograma 
	from	proj_cronograma e, 
		prp_processo_fase p, 
		prp_fase_processo f 
	where	p.nr_Sequencia = e.nr_seq_processo_fase 
	and	f.nr_sequencia = p.nr_seq_fase_processo 
	and	e.nr_seq_proj = nr_seq_proj_p 
	and (obter_acesso_cronograma_npi(nr_seq_proj_p, f.nr_sequencia, nm_usuario_p, 'V') = 'S');
	
c02 CURSOR FOR  --seleciona as etapas conforme o cronograma 
	SELECT	nr_sequencia 
	from 	proj_cron_etapa 
	where 	nr_seq_cronograma = nr_seq_proj_cro_w;
	
c03 CURSOR FOR  --seleciona as OS's de cada etapa 
	SELECT	v.nr_sequencia 
	from	man_ordem_servico_v v 
	where	nr_seq_proj_cron_etapa = nr_seq_cro_eta_w;
	

BEGIN 
 
	open c01;
	loop 
	fetch c01 into 
		nr_seq_proj_cro_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		----INICIO CURSOR C02 
		open c02;
		loop 
		fetch c02 into 
			nr_seq_cro_eta_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			--INICIO CURSOR C03		 
			open c03;
			loop 
			fetch c03 into 
				nr_seq_os_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				 
				select ds_historico 
				into STRICT ds_his_w 
				from com_cliente_hist 
				where nr_seq_projeto = nr_seq_proj_p 
				and nr_seq_tipo = 21;
				 
				insert 
					into	man_ordem_serv_tecnico(nr_sequencia, 
							nr_seq_ordem_serv, 
							dt_atualizacao, 
							dt_historico, 
							dt_liberacao, 
							nm_usuario, 
							nr_seq_tipo, 
							ie_origem, 
							ds_relat_tecnico) 
					values ( nextval('man_ordem_serv_tecnico_seq'), 
							 nr_seq_os_w, 
							 clock_timestamp(), 
							 clock_timestamp(), 
							 clock_timestamp(), 
							 nm_usuario_p, 
							 72, 
							 'I', 
							 ds_his_w);
				 
				CALL man_cancelar_ordem_servico(nr_seq_os_w, nr_seq_motivo_cancel_p, nr_seq_estagio_cancel_p, nm_usuario_p);
			end loop;
			close c03;
			--FIM CURSOR C03 
		end loop;
		close c02;
		----FIM CURSOR C02 
	end loop;
	close c01;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_ordem_serv_cron ( nr_seq_proj_p bigint, nr_seq_motivo_cancel_p bigint, nr_seq_estagio_cancel_p bigint, nm_usuario_p text) FROM PUBLIC;
