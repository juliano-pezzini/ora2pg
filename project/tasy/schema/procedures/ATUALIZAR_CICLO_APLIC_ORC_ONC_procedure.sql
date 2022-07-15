-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (ds_dias_aplicacao varchar(255));


CREATE OR REPLACE PROCEDURE atualizar_ciclo_aplic_orc_onc (nr_seq_orcamento_p bigint, nr_seq_mat_orcamento_p bigint, nm_usuario_p text) AS $body$
DECLARE

	
ds_ciclos_aplic_filtro_w	orcamento_paciente.ds_ciclos_aplic_filtro%type;
ds_ciclos_aplicacao_w		orcamento_paciente_mat.ds_ciclos_aplicacao%type;
nr_sequencia_w			orcamento_paciente_mat.nr_sequencia%type;

ds_retorno_w 			varchar(255);
qt_ciclo_w 			numeric(30);
k    				bigint;
p    				bigint;
w    				bigint;
qt_ciclo_w2 			numeric(30);
ie_regra_apresent_quimio_w	varchar(1);

indice_w			bigint := 0;
ds_valido_ciclo_w		varchar(255) := '0123456789C,- ';
dia_ciclo_w			varchar(255) := '';
type vetor 			is table of campos index by integer;
ciclo_w				vetor;
ciclo_vazio_w			vetor;
ciclo_filtro_w			vetor;
indice_ciclo_w			bigint := 0;
posicao_virg_w			bigint := 0;
indice_loop_w			bigint := 0;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_ciclos_aplicacao
	from	orcamento_paciente_mat
	where	nr_sequencia_orcamento = nr_seq_orcamento_p
	and	((coalesce(nr_seq_mat_orcamento_p::text, '') = '') or (coalesce(nr_sequencia, nr_seq_mat_orcamento_p) = nr_seq_mat_orcamento_p))
	and 	(ds_ciclos_aplicacao IS NOT NULL AND ds_ciclos_aplicacao::text <> '')
	order by nr_sequencia;
	

BEGIN

if (coalesce(nr_seq_orcamento_p,0) > 0) then

	select	max(ds_ciclos_aplic_filtro)
	into STRICT	ds_ciclos_aplic_filtro_w
	from 	orcamento_paciente b
	where	b.nr_sequencia_orcamento = nr_seq_orcamento_p;

	if (ds_ciclos_aplic_filtro_w IS NOT NULL AND ds_ciclos_aplic_filtro_w::text <> '') then

		for indice_w in 1..length(ds_ciclos_aplic_filtro_w) loop
			dia_ciclo_w	:= substr(upper(ds_ciclos_aplic_filtro_w), indice_w, 1);
			if (position(dia_ciclo_w in ds_valido_ciclo_w) = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1084612);
			end if;
		end loop;

		while (ds_ciclos_aplic_filtro_w IS NOT NULL AND ds_ciclos_aplic_filtro_w::text <> '') loop
			ds_ciclos_aplic_filtro_w := substr(ds_ciclos_aplic_filtro_w, position('C' in ds_ciclos_aplic_filtro_w) + 1, length(ds_ciclos_aplic_filtro_w));
			posicao_virg_w	:= position('C' in ds_ciclos_aplic_filtro_w);
			indice_ciclo_w := indice_ciclo_w + 1;
			
			if (posicao_virg_w = 0) then
				ciclo_filtro_w[indice_ciclo_w].ds_dias_aplicacao	:= 'C' || somente_numero_real(substr(ds_ciclos_aplic_filtro_w,1,length(ds_ciclos_aplic_filtro_w)));
				ds_ciclos_aplic_filtro_w := '';
			else
				ciclo_filtro_w[indice_ciclo_w].ds_dias_aplicacao	:= 'C' || somente_numero_real(substr(ds_ciclos_aplic_filtro_w,1,posicao_virg_w - 2));
				
				ds_ciclos_aplic_filtro_w := substr(ds_ciclos_aplic_filtro_w,posicao_virg_w, length(ds_ciclos_aplic_filtro_w));
			end if;
			
			if (position('C' in ciclo_filtro_w[indice_ciclo_w].ds_dias_aplicacao) = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(1084612);
			end if;
			indice_loop_w := indice_loop_w + 1;
			if (indice_loop_w > 100) then
				exit;
			end if;
		end loop;

		qt_ciclo_w	:= ciclo_filtro_w.count;
		
		open C01;
		loop
		fetch C01 into
			nr_sequencia_w,
			ds_ciclos_aplicacao_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			for indice_w in 1..length(ds_ciclos_aplicacao_w) loop
				dia_ciclo_w	:= substr(upper(ds_ciclos_aplicacao_w), indice_w, 1);
				if (position(dia_ciclo_w in ds_valido_ciclo_w) = 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(1084612);
				end if;
			end loop;
			
			indice_ciclo_w	:= 0;
			indice_loop_w	:= 0;
			ciclo_w		:= ciclo_vazio_w;

			while (ds_ciclos_aplicacao_w IS NOT NULL AND ds_ciclos_aplicacao_w::text <> '') loop
				ds_ciclos_aplicacao_w := substr(ds_ciclos_aplicacao_w, position('C' in ds_ciclos_aplicacao_w) + 1, length(ds_ciclos_aplicacao_w));
				posicao_virg_w	:= position('C' in ds_ciclos_aplicacao_w);
				indice_ciclo_w := indice_ciclo_w + 1;
				
				if (posicao_virg_w = 0) then
					ciclo_w[indice_ciclo_w].ds_dias_aplicacao	:= 'C' || somente_numero_real(substr(ds_ciclos_aplicacao_w,1,length(ds_ciclos_aplicacao_w)));
					ds_ciclos_aplicacao_w := '';
				else
					ciclo_w[indice_ciclo_w].ds_dias_aplicacao	:= 'C' || somente_numero_real(substr(ds_ciclos_aplicacao_w,1,posicao_virg_w - 2));
					
					ds_ciclos_aplicacao_w := substr(ds_ciclos_aplicacao_w,posicao_virg_w, length(ds_ciclos_aplicacao_w));
				end if;
				
				if (position('C' in ciclo_w[indice_ciclo_w].ds_dias_aplicacao)	= 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(1084612);
				end if;
				indice_loop_w := indice_loop_w + 1;
				if (indice_loop_w > 100) then
					exit;
				end if;
			end loop;
			
			qt_ciclo_w2	:= ciclo_w.count;
			ds_retorno_w	:= '';
					
			for k in 1.. qt_ciclo_w2 loop
				
				begin
	
				for p in 1.. qt_ciclo_w loop
					
					begin
					
					if (ciclo_filtro_w[p].ds_dias_aplicacao = ciclo_w[k].ds_dias_aplicacao) then
						if (coalesce(ds_retorno_w::text, '') = '') then
							ds_retorno_w := ciclo_filtro_w[p].ds_dias_aplicacao;
						else
							ds_retorno_w := ds_retorno_w || ' ' || ciclo_filtro_w[p].ds_dias_aplicacao;
						end if;
					end if;
					
					end;
				
				end loop;
				
				end;
			
			end loop;
	  
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				
				update	orcamento_paciente_mat
				set 	ds_ciclos_aplic_orig = ds_ciclos_aplicacao,
					ds_ciclos_aplicacao  = ds_retorno_w
				where 	nr_sequencia_orcamento = nr_seq_orcamento_p
				and 	nr_sequencia = nr_sequencia_w;
				
			else
		
				delete from orcamento_paciente_mat
				where 	nr_sequencia_orcamento = nr_seq_orcamento_p
				and 	nr_sequencia = nr_sequencia_w;
				
			end if;
			
			end;
		end loop;
		close C01;
		
		commit;
		
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ciclo_aplic_orc_onc (nr_seq_orcamento_p bigint, nr_seq_mat_orcamento_p bigint, nm_usuario_p text) FROM PUBLIC;

