-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_exportar_xml_pck.salvarminmaxocorrencias () AS $body$
DECLARE

	qt_log_integracao_w integer;
	
BEGIN
		if (current_setting('wheb_exportar_xml_pck.nr_seq_log_w')::(bigint IS NOT NULL AND bigint::text <> '')) and (current_setting('wheb_exportar_xml_pck.ds_ocorrencias_w')::(varchar(4000) IS NOT NULL AND (varchar(4000))::text <> '')) then
			if (current_setting('wheb_exportar_xml_pck.ie_tipo_w')::varchar(60) = 'INTEGRACAO') then
				/* Apenas para garantir que existe a integracao */


				select count(1)
				  into STRICT qt_log_integracao_w
				  from log_integracao
				 where nr_sequencia = current_setting('wheb_exportar_xml_pck.nr_seq_log_w')::bigint;

				if (qt_log_integracao_w > 0) then
					/* Inseri o registro referente as ocorrencias que foram encontradas e devem ser ajustadas seguindo as regras do projeto XML */


					insert into log_integracao_evento(
						nr_sequencia,
						nr_seq_log,
						ie_tipo_evento,
						ie_envio_retorno,
						cd_evento,
						ds_observacao,
						dt_atualizacao,
						nm_usuario)
					VALUES (
						nextval('log_integracao_evento_seq'),
						current_setting('wheb_exportar_xml_pck.nr_seq_log_w')::bigint,
						'O',
						'R',
						'ER',
						current_setting('wheb_exportar_xml_pck.ds_ocorrencias_w')::varchar(4000),
						clock_timestamp(),
						'Tasy');
						
					update	agendamento_integracao
					set 	ie_status	= 'O'
					where	nr_seq_log	= current_setting('wheb_exportar_xml_pck.nr_seq_log_w')::bigint;
				end if;
			end if;
		end if;
	end;
	
	--Quando alterar este metodo, verificar se nao eh necessario alterar o metodo addValorXML, no outro metodo somente guarda os valores do XML


$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON PROCEDURE wheb_exportar_xml_pck.salvarminmaxocorrencias () FROM PUBLIC;
