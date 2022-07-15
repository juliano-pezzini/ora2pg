-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_desvinc_atend_agen_quimio ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


										  
parametro17_w		varchar(1);
nr_atendimento_w	bigint;
nr_seq_atendimento_w	paciente_atendimento.nr_seq_atendimento%type;
										

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then


	select 	max(nr_atendimento),
            max(nr_seq_atendimento)
	into STRICT	nr_atendimento_w,
            nr_seq_atendimento_w
	from	agenda_quimio
	where	nr_sequencia = nr_sequencia_p;

	parametro17_w := obter_param_usuario(865, 17, Obter_perfil_Ativo, nm_usuario_p, 0, parametro17_w);
	
	if ( parametro17_w = 'S') then
	
		CALL qt_atualizar_aut_convenio(nr_atendimento_w, nr_seq_atendimento_w, 'DA', nm_usuario_p);
		
		CALL desvincular_atend_agen_quimio(nm_usuario_p, nr_sequencia_p);
		
	end if;
	

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_desvinc_atend_agen_quimio ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

