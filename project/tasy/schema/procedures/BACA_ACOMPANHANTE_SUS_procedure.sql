-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acompanhante_sus (nr_seq_protocolo_p bigint) AS $body$
DECLARE

 
nm_usuario_w			varchar(15);
nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;

C000 CURSOR FOR 
SELECT a.nr_atendimento, a.nr_interno_conta, a.nm_usuario 
from sus_aih b, conta_paciente a 
where a.nr_seq_protocolo = nr_seq_protocolo_p 
 and a.nr_atendimento = b.nr_atendimento 
 and b.qt_dia_acompanhante > 0 
 and not exists (SELECT 1 
	from procedimento_paciente c 
	where a.nr_interno_conta = c.nr_interno_conta 
	 and c.cd_procedimento = 99080011);


BEGIN 
 
OPEN C000;
LOOP 
FETCH C000 INTO 
	nr_atendimento_w, 
	nr_interno_conta_w, 
	nm_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on c000 */
	begin 
	CALL Gravar_Proc_Adicional_Sus( 
			nr_interno_conta_w, 
			nr_atendimento_w, 
			nm_usuario_w);
	end;
END LOOP;
CLOSE C000;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acompanhante_sus (nr_seq_protocolo_p bigint) FROM PUBLIC;
