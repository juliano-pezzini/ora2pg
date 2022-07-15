-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE confirmar_diag_pend ( nr_sequencia_p text, nr_atendimento_p bigint, cd_doenca_p text, cd_medico_p text, nm_usuario_p text, nr_seq_doen_prev_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text) AS $body$
WITH RECURSIVE cte AS (
DECLARE

				
				
c01 CURSOR FOR
	SELECT regexp_substr(nr_sequencia_p,'[^,]+', 1, level) as seq,
	 regexp_substr(cd_doenca_p,'[^,]+', 1, level) as doenca,
	regexp_substr(nr_seq_doen_prev_p,'[^,]+', 1, level) as doenca_prev
	
	(regexp_substr(nr_sequencia_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_sequencia_p, '[^,]+', 1, level))::text <> '')  UNION ALL
DECLARE

				
				
c01 CURSOR FOR
	SELECT regexp_substr(nr_sequencia_p,'[^,]+', 1, level) as seq,
	 regexp_substr(cd_doenca_p,'[^,]+', 1, level) as doenca,
	regexp_substr(nr_seq_doen_prev_p,'[^,]+', 1, level) as doenca_prev
	 
	(regexp_substr(nr_sequencia_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_sequencia_p, '[^,]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;
	
c01_w	c01%rowtype;	
	

BEGIN

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
begin
	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (c01_w.seq IS NOT NULL AND c01_w.seq::text <> '') then
	begin
	  if ((c01_w.doenca IS NOT NULL AND c01_w.doenca::text <> '') or c01_w.doenca != '') then
		CALL gerar_diag_pend_atend(nr_atendimento_p,c01_w.doenca,cd_medico_p,nm_usuario_p,ie_tipo_diagnostico_p,ie_classificacao_doenca_p,c01_w.doenca_prev);
	  end if;
	  CALL atualizar_data_geracao(c01_w.seq,nm_usuario_p);
	end;
end if;
end;
end loop;
close c01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE confirmar_diag_pend ( nr_sequencia_p text, nr_atendimento_p bigint, cd_doenca_p text, cd_medico_p text, nm_usuario_p text, nr_seq_doen_prev_p text, ie_tipo_diagnostico_p bigint, ie_classificacao_doenca_p text) FROM PUBLIC;

