-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_duplica_cad_conjunto ( nr_seq_conj_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE


nm_conjunto_w				cm_conjunto.nm_conjunto%type;
nr_seq_classif_w			cm_conjunto.nr_seq_classif%type;
ie_situacao_w				varchar(1);
nr_seq_embalagem_w			cm_conjunto.nr_seq_embalagem%type;
ie_controle_fisico_w			cm_conjunto.ie_controle_fisico%type;
ds_conjunto_w				cm_conjunto.ds_conjunto%type;
cd_estabelecimento_w			smallint;
qt_ponto_w				cm_conjunto.qt_ponto%type;
cd_setor_atendimento_w			integer;
qt_limite_esterilizacao_w		cm_conjunto.qt_limite_esterilizacao%type;
qt_tempo_esterelizacao_w		cm_conjunto.qt_tempo_esterelizacao%type;
dt_revisao_w				cm_conjunto.dt_revisao%type;
qt_min_intervalo_prep_w			cm_conjunto.qt_min_intervalo_prep%type;
ds_observacao_w				varchar(255);
ds_reduzida_w				cm_conjunto.ds_reduzida%type;
cd_especialidade_w			cm_conjunto.cd_especialidade%type;
qt_consiste_agenda_w			cm_conjunto.qt_consiste_agenda%type;
cd_medico_w				cm_conjunto.cd_medico%type;
nr_agrupador_w				cm_conjunto.nr_agrupador%type;
nr_sequencia_w				bigint;
qt_cota_conjunto_w			bigint;
qt_itens_conjunto_w			bigint;
qt_anexo_conjunto_w			bigint;
ie_agendamento_w			cm_conjunto.ie_agendamento%type;
ie_administracao_w			varchar(1);
ie_requisicao_w				cm_conjunto.ie_requisicao%type;
ie_reserva_w				cm_conjunto.ie_reserva%type;
nr_seq_generico_w			cm_conjunto.nr_seq_generico%type;
qt_conjunto_w				cm_conjunto.qt_conjunto%type;
nr_seq_interno_w			cm_conjunto.nr_seq_interno%type;
ie_gerar_novo_item_w			varchar(1);
ds_cor_conjunto_w			cm_conjunto.ds_cor_conjunto%type;
ie_gerar_conj_auto_w			cm_conjunto.ie_gerar_conj_auto%type;
ie_periodo_w				cm_conjunto_cota.ie_periodo%type;
qt_conjunto_cota_w			cm_conjunto_cota.qt_conjunto%type;
nr_sequencia_cota_w			cm_conjunto_cota.nr_sequencia%type;
nr_seq_item_w				bigint;
qt_item_w				 cm_conjunto_item.qt_item%type;
ie_indispensavel_w			cm_conjunto_item.ie_indispensavel%type;
ds_arquivo_w				cm_conjunto_anexo.ds_arquivo%type;
nr_sequencia_anexo_w			cm_conjunto_anexo.nr_sequencia%type;
nr_seq_padrao_local_w			cm_conjunto_padrao_local.nr_sequencia%type;
qt_padrao_local_w			bigint;
cd_local_estoque_w			cm_conjunto_padrao_local.cd_local_estoque%type;
qt_minimo_conjunto_w			cm_conjunto_padrao_local.qt_minimo_conjunto%type;
cd_codigo_w				cm_conjunto_item.cd_codigo%type;
nr_seq_interno_item_w			cm_conjunto_item.nr_seq_interno%type;
ie_status_item_w			cm_conjunto_item.ie_status_item%type;
nr_seq_conj_fixo_w			cm_conjunto_item.nr_seq_conj_fixo%type;
nr_seq_item_fixo_w			cm_conjunto_item.nr_seq_item_fixo%type;
dt_subst_fixo_w				cm_conjunto_item.dt_subst_fixo%type;
nm_usuario_fixo_w			cm_conjunto_item.nm_usuario_fixo%type;
nr_seq_apresentacao_w			cm_conjunto_item.nr_seq_apresentacao%type;

c01 CURSOR FOR
	SELECT	nm_conjunto,
		nr_seq_classif,
		ie_situacao,
		nr_seq_embalagem,
		ie_controle_fisico,
		ds_conjunto,
		cd_estabelecimento,
		qt_ponto,
		cd_setor_atendimento,
		qt_limite_esterilizacao,
		qt_tempo_esterelizacao,
		dt_revisao,
		qt_min_intervalo_prep,
		ds_observacao,
		ds_reduzida,
		cd_especialidade,
		qt_consiste_agenda,
		cd_medico,
		nr_agrupador,
		ie_agendamento,
		ie_administracao,
		ie_requisicao,
		ie_reserva,
		nr_seq_generico,
		qt_conjunto,
		ds_cor_conjunto,
		ie_gerar_conj_auto
	from	cm_conjunto
	where 	nr_sequencia = nr_seq_conj_p
	and	cd_estabelecimento = cd_estabelecimento_p;

c02 CURSOR FOR
	SELECT	cd_setor_atendimento,
		ie_periodo,
		ie_situacao,
		qt_conjunto
	from	cm_conjunto_cota
	where	nr_seq_conjunto = nr_seq_conj_p
	and	cd_estabelecimento = cd_estabelecimento_p;

c03 CURSOR FOR
	SELECT	nr_seq_item,
		qt_item,
		coalesce(ie_indispensavel,'N'),
		cd_codigo,
		nr_seq_interno,
		ie_status_item,
		nr_seq_conj_fixo,
		nr_seq_item_fixo,
		dt_subst_fixo,
		nm_usuario_fixo,
		nr_seq_apresentacao
	from	cm_conjunto_item
	where	nr_seq_conjunto = nr_seq_conj_p
	order by nr_seq_interno;

c04 CURSOR FOR
	SELECT	ds_arquivo
	from	cm_conjunto_anexo
	where	nr_seq_conjunto = nr_seq_conj_p;

c05 CURSOR FOR
	SELECT	cd_local_estoque,
		qt_minimo_conjunto
	from	cm_conjunto_padrao_local
	where	nr_seq_conjunto = nr_seq_conj_p;


BEGIN

ie_gerar_novo_item_w := obter_valor_param_usuario(406,103,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_p);

select	count(*)
into STRICT	qt_cota_conjunto_w
from	cm_conjunto_cota
where	nr_seq_conjunto = nr_seq_conj_p
and	cd_estabelecimento = cd_estabelecimento_p;

select	count(*)
into STRICT	qt_itens_conjunto_w
from	cm_conjunto_item
where	nr_seq_conjunto = nr_seq_conj_p;

select	count(*)
into STRICT	qt_anexo_conjunto_w
from	cm_conjunto_anexo
where	nr_seq_conjunto = nr_seq_conj_p;

select	count(*)
into STRICT	qt_padrao_local_w
from	cm_conjunto_padrao_local
where	nr_seq_conjunto = nr_seq_conj_p;

open c01;
loop
fetch c01 into	
	nm_conjunto_w,
	nr_seq_classif_w,
	ie_situacao_w,
	nr_seq_embalagem_w,
	ie_controle_fisico_w,
	ds_conjunto_w,
	cd_estabelecimento_w,
	qt_ponto_w,
	cd_setor_atendimento_w,
	qt_limite_esterilizacao_w,
	qt_tempo_esterelizacao_w,
	dt_revisao_w,
	qt_min_intervalo_prep_w,
	ds_observacao_w,
	ds_reduzida_w,
	cd_especialidade_w,
	qt_consiste_agenda_w,
	cd_medico_w,
	nr_agrupador_w,
	ie_agendamento_w,
	ie_administracao_w,
	ie_requisicao_w,
	ie_reserva_w,
	nr_seq_generico_w,
	qt_conjunto_w,
	ds_cor_conjunto_w,
	ie_gerar_conj_auto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	coalesce(max(nr_seq_interno),0) + 1
	into STRICT	nr_seq_interno_w
	from	cm_conjunto
	where	nr_seq_classif = nr_seq_classif_w
	and	cd_estabelecimento = cd_estabelecimento_p;
	
	select	nextval('cm_conjunto_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into cm_conjunto(nr_sequencia,
				nm_conjunto,                    
				nr_seq_classif,                 
				dt_atualizacao,                
				nm_usuario,                     
				ie_situacao,                    
				nr_seq_embalagem,               
				ie_controle_fisico,             
				ds_conjunto,                    
				cd_estabelecimento,             
				qt_ponto,                       
				cd_setor_atendimento,           
				qt_limite_esterilizacao,        
				qt_tempo_esterelizacao,         
				dt_revisao,                     
				qt_min_intervalo_prep,          
				ds_reduzida,                    
				cd_especialidade,               
				qt_consiste_agenda,             
				cd_medico,                      
				nr_agrupador,
				ie_agendamento,
				ie_requisicao,
				ie_reserva,
				nr_seq_generico,
				qt_conjunto,
				ds_cor_conjunto,
				nr_seq_interno,
				ie_gerar_conj_auto,
				ds_observacao)   values (
						nr_sequencia_w,
						nm_conjunto_w,
						nr_seq_classif_w,
						clock_timestamp(),
						nm_usuario_p,
						ie_situacao_w,
						nr_seq_embalagem_w,
						ie_controle_fisico_w,
						ds_conjunto_w,
						cd_estabelecimento_w,
						qt_ponto_w,
						cd_setor_atendimento_w,
						qt_limite_esterilizacao_w,
						qt_tempo_esterelizacao_w,
						dt_revisao_w,
						qt_min_intervalo_prep_w,
						ds_reduzida_w,
						cd_especialidade_w,
						qt_consiste_agenda_w,
						cd_medico_w,
						nr_agrupador_w,
						ie_agendamento_w,
						ie_requisicao_w,
						ie_reserva_w,
						nr_seq_generico_w,
						qt_conjunto_w,
						ds_cor_conjunto_w,
						nr_seq_interno_w,
						ie_gerar_conj_auto_w,
						wheb_mensagem_pck.get_texto(310998) || ': ' ||nr_seq_conj_p||' - '||ds_observacao_w);
	
	if (qt_cota_conjunto_w > 0) then
		begin
		open c02;
		loop
		fetch c02 into
			cd_setor_atendimento_w,
			ie_periodo_w,
			ie_situacao_w,
			qt_conjunto_cota_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin	
			
			select	nextval('cm_conjunto_cota_seq')
			into STRICT	nr_sequencia_cota_w
			;
			
			insert into cm_conjunto_cota(nr_sequencia,
						  cd_estabelecimento,
						  qt_conjunto,
						  ie_periodo,
						  dt_atualizacao,
						  nm_usuario,
						  dt_atualizacao_nrec,
						  nm_usuario_nrec,
						  nr_seq_conjunto,
						  cd_setor_atendimento,
						  ie_situacao) values (nr_sequencia_cota_w,
								   cd_estabelecimento_w,
								   qt_conjunto_cota_w,
								   ie_periodo_w,
								   clock_timestamp(),
								   nm_usuario_p,
								   clock_timestamp(),
								   nm_usuario_p,
								   nr_sequencia_w,
								   cd_setor_atendimento_w,
								   ie_situacao_w);	
															
			end;
		end loop;
		close c02;	
		end;
	end if;
	
	if (qt_itens_conjunto_w > 0) then
		begin		
		open c03;
		loop
		fetch c03 into
			nr_seq_item_w,
			qt_item_w,
			ie_indispensavel_w,
			cd_codigo_w,
			nr_seq_interno_item_w,
			ie_status_item_w,
			nr_seq_conj_fixo_w,
			nr_seq_item_fixo_w,
			dt_subst_fixo_w,
			nm_usuario_fixo_w,
			nr_seq_apresentacao_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			if (ie_gerar_novo_item_w = 'N') then
				begin

				insert into cm_conjunto_item(
					nr_seq_conjunto,
					nr_seq_item,
					qt_item,
					dt_atualizacao,
					nm_usuario,
					ie_indispensavel,
					cd_codigo,
					nr_seq_interno,
					ie_status_item,
					nr_seq_conj_fixo,
					nr_seq_item_fixo,
					dt_subst_fixo,
					nm_usuario_fixo,
					nr_seq_apresentacao)
				values (nr_sequencia_w,
					nr_seq_item_w,
					qt_item_w,
					clock_timestamp(),
					nm_usuario_p,
					ie_indispensavel_w,
					cd_codigo_w,
					nr_seq_interno_item_w,
					ie_status_item_w,
					nr_seq_conj_fixo_w,
					nr_seq_item_fixo_w,
					dt_subst_fixo_w,
					nm_usuario_fixo_w,
					nr_seq_apresentacao_w);

				end;
			else
				CALL cm_copia_item_conjunto(nr_seq_item_w,nr_seq_conj_p,nr_sequencia_w,qt_item_w,ie_indispensavel_w,1,cd_estabelecimento_p,nm_usuario_p);
			end if;
															
			end;
		end loop;
		close c03;
		end;
	end if;
	
	if (qt_anexo_conjunto_w > 0) then
		begin
		open c04;
		loop
		fetch c04 into
			ds_arquivo_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
			
			select	nextval('cm_conjunto_anexo_seq')
			into STRICT	nr_sequencia_anexo_w
			;
			
			insert into cm_conjunto_anexo(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_conjunto,
						ds_arquivo) values (nr_sequencia_anexo_w,
								   clock_timestamp(),
								   nm_usuario_p,
								   clock_timestamp(),
								   nm_usuario_p,
								   nr_sequencia_w,
								   ds_arquivo_w);
			
			end;
		end loop;
		close c04;
		end;
	end if;

	if (qt_padrao_local_w > 0) then
		begin
		open c05;
		loop
		fetch c05 into
			cd_local_estoque_w,
			qt_minimo_conjunto_w;
		EXIT WHEN NOT FOUND; /* apply on c05 */
			begin

			select	nextval('cm_conjunto_padrao_local_seq')
			into STRICT	nr_seq_padrao_local_w
			;
			
			insert into cm_conjunto_padrao_local(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_conjunto,
				cd_local_estoque,
				qt_minimo_conjunto) values (
					nr_seq_padrao_local_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_sequencia_w,
					cd_local_estoque_w,
					qt_minimo_conjunto_w);

			end;
		end loop;
		close c05;

		end;
	end if;										
	
	end;
end loop;
close c01;

nr_sequencia_p := nr_sequencia_w;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_duplica_cad_conjunto ( nr_seq_conj_p bigint, cd_estabelecimento_p bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;

