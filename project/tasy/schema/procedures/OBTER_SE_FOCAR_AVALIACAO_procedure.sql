-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_focar_avaliacao (nr_prescricao_p bigint, ie_foco_p INOUT text) AS $body$
DECLARE

 
nr_seq_avaliacao_w bigint := 0;

c01 CURSOR FOR 
SELECT nr_prescricao prescricao, nr_sequencia sequencia 
FROM PRESCR_PROCEDIMENTO b 
WHERE b.nr_prescricao = nr_prescricao_p;

c01_w	c01%rowtype;


BEGIN 
 
ie_foco_p := '';
 
open c01;
loop 
  fetch c01 into c01_w;
  EXIT WHEN NOT FOUND; /* apply on c01 */
 
	nr_seq_avaliacao_w := Gerar_Avaliacao_Proced_Exame(c01_w.prescricao, c01_w.sequencia, obter_usuario_ativo, nr_seq_avaliacao_w);
			 
	if (nr_seq_avaliacao_w > 0 
		and coalesce(ie_foco_p::text, '') = '') then 
	  ie_foco_p := 'S';
	end if;
 
end loop;
close c01;
 
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_focar_avaliacao (nr_prescricao_p bigint, ie_foco_p INOUT text) FROM PUBLIC;
