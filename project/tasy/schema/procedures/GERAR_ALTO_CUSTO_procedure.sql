-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alto_custo ( dt_inicio_p diagnostico_doenca.dt_diagnostico%TYPE, dt_fim_p diagnostico_doenca.dt_diagnostico%TYPE, ie_tipo_doenca_p regra_alto_custo.ie_tipo_doenca%TYPE, nr_seq_alto_custo_p alto_custo.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE) AS $body$
DECLARE

							
nm_usuario_w         usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;


BEGIN
	
	CALL alto_custo_pck.gerar_pacientes(	dt_inicio_p,
									dt_fim_p,
									ie_tipo_doenca_p,
									nr_seq_alto_custo_p,
									nm_usuario_p);
											

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alto_custo ( dt_inicio_p diagnostico_doenca.dt_diagnostico%TYPE, dt_fim_p diagnostico_doenca.dt_diagnostico%TYPE, ie_tipo_doenca_p regra_alto_custo.ie_tipo_doenca%TYPE, nr_seq_alto_custo_p alto_custo.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE) FROM PUBLIC;
