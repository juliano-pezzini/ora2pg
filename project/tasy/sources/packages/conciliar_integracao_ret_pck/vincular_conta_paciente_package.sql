-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integracao_ret_pck.vincular_conta_paciente () AS $body$
BEGIN

if (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.count > 0) then

	for i in current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.first .. current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v.last loop

		if current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas.count > 0 then

			for j in current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas.first .. current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas.last loop

				if (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta = 0)
					and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia.count > 0) then					
					for k in current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia.first .. current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia.last loop

						if (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_seq_conta_guia = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_sequencia) then
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';
						elsif (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_guia_prestador) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_operadora = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_autorizacao) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).cd_senha = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_senha) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).vl_informado = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).vl_total) then

							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';

						elsif (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_guia_prestador) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_operadora = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_autorizacao) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).cd_senha = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_senha) then

							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';

						elsif (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_guia_prestador) and (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_operadora = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_autorizacao) then

							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';

						elsif (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_guia_prestador) then

							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;	
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';

						elsif (current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_guia_prestador = current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).cd_autorizacao) then

							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).nr_interno_conta 	:= current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].conta_guia(k).nr_interno_conta;
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status 		:= 'C';

						else	
							current_setting('conciliar_integracao_ret_pck.protocolos_w')::protocolo_v[i].contas(j).ie_status := 'CN'; --'Conta Paciente nao encontrada!';
						end if;

					end loop;
				end if;

			end loop;

		end if;

	end loop;

end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integracao_ret_pck.vincular_conta_paciente () FROM PUBLIC;