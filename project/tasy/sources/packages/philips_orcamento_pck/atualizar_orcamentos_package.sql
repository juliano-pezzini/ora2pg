-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/* Rotina que atualiza os valores totais recebidos e distribuidos, e o valor pendente à distribuir na repetição */

CREATE OR REPLACE PROCEDURE philips_orcamento_pck.atualizar_orcamentos ( ds_idx_centro_p text) AS $body$
BEGIN
	if (ds_idx_centro_p = 'X') then
		begin
		if (orcamentos.count > 0) then
			begin
			ds_idx_centro_w := orcamentos.first;
			while(ds_idx_centro_w IS NOT NULL AND ds_idx_centro_w::text <> '') loop
				begin
				if (orcamentos[ds_idx_centro_w].orcamento.count > 0) then
					begin
					ds_idx_orcamento_custo_w := orcamentos[ds_idx_centro_w].orcamento.first;
					while(ds_idx_orcamento_custo_w IS NOT NULL AND ds_idx_orcamento_custo_w::text <> '') loop
						begin
						orcamento_atual := orcamentos[ds_idx_centro_w].orcamento(ds_idx_orcamento_custo_w);
						/* Atualizar o valor a distribuir com o valor recebido, acumular valor recebido, zerar valor recebido na distribuição anterior */

						orcamento_atual.vl_pendente := orcamento_atual.vl_pendente + orcamento_atual.vl_receb_distrib;
						orcamento_atual.vl_a_distribuir := orcamento_atual.vl_pendente;
						orcamento_atual.vl_receb_distrib_acum := orcamento_atual.vl_receb_distrib_acum + orcamento_atual.vl_receb_distrib;
						orcamento_atual.vl_receb_distrib := 0;

						orcamento_atual.vl_distribuido_acum := orcamento_atual.vl_distribuido_acum + orcamento_atual.vl_distribuido;
						orcamento_atual.vl_distribuido := 0;

						/* Voltar o registro para o array com os valores atualizados */

						orcamentos[ds_idx_centro_w].orcamento(ds_idx_orcamento_custo_w) := orcamento_atual;
						/* Indice do próximo orçamento */

						ds_idx_orcamento_custo_w := orcamentos[ds_idx_centro_w].orcamento.next(ds_idx_orcamento_custo_w);
						end;
					end loop;
					end;
				end if;
				/* Indice do próximo centro */

				ds_idx_centro_w := orcamentos.next(ds_idx_centro_w);
				end;
			end loop;
			end;
		end if;
		end;
	else
		begin
		if (orcamentos.exists(ds_idx_centro_p)) and (orcamentos[ds_idx_centro_p].orcamento.count > 0) then
			begin
			ds_idx_orcamento_custo_w := orcamentos[ds_idx_centro_p].orcamento.first;
			while(ds_idx_orcamento_custo_w IS NOT NULL AND ds_idx_orcamento_custo_w::text <> '') loop
				begin
				orcamento_atual := orcamentos[ds_idx_centro_p].orcamento(ds_idx_orcamento_custo_w);
				/* Atualizar o valor a distribuir com o valor recebido, acumular valor recebido, zerar valor recebido na distribuição anterior */

				orcamento_atual.vl_pendente := orcamento_atual.vl_pendente + orcamento_atual.vl_receb_distrib;
				orcamento_atual.vl_a_distribuir := orcamento_atual.vl_pendente;
				orcamento_atual.vl_receb_distrib_acum := orcamento_atual.vl_receb_distrib_acum + orcamento_atual.vl_receb_distrib;
				orcamento_atual.vl_receb_distrib := 0;

				orcamento_atual.vl_distribuido_acum := orcamento_atual.vl_distribuido_acum + orcamento_atual.vl_distribuido;
				orcamento_atual.vl_distribuido := 0;

				/* Voltar o registro para o array com os valores atualizados */

				orcamentos[ds_idx_centro_p].orcamento(ds_idx_orcamento_custo_w) := orcamento_atual;
				/* Indice do próximo orçamento */

				ds_idx_orcamento_custo_w := orcamentos[ds_idx_centro_p].orcamento.next(ds_idx_orcamento_custo_w);
				end;
			end loop;
			end;
		end if;
		end;
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE philips_orcamento_pck.atualizar_orcamentos ( ds_idx_centro_p text) FROM PUBLIC;
