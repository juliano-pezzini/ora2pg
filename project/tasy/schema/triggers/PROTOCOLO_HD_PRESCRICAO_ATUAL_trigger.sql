-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS protocolo_hd_prescricao_atual ON protocolo_hd_prescricao CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_protocolo_hd_prescricao_atual() RETURNS trigger AS $BODY$
declare

BEGIN

if (obter_se_prot_lib_regras = 'S') then
	update	protocolo_medicacao
	set	nm_usuario_aprov	 = NULL,
		dt_aprovacao		 = NULL,
		ie_status		=	'PA'
	where	cd_protocolo		=	NEW.cd_protocolo
	and	nr_sequencia		=	NEW.nr_seq_protocolo;
end if;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_protocolo_hd_prescricao_atual() FROM PUBLIC;

CREATE TRIGGER protocolo_hd_prescricao_atual
	BEFORE INSERT OR UPDATE ON protocolo_hd_prescricao FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_protocolo_hd_prescricao_atual();

