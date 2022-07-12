-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_ret_item_fonetica_pck.valida_exibicao_item_section (DS_ITEM_P text, DS_ITEM_FONETICA_P text, NR_SEQ_GRUPO_P bigint, NR_SEQ_AREA_P bigint) RETURNS varchar AS $body$
DECLARE

	
	PSEUDONIMO_V smallint :=0;
	FONETICA_V smallint := 0;
	IE_EXIBE_ITEM_P_V varchar(1) := 'S';
	IE_EXIBE_ITEM_F_V varchar(1) := 'S';
	IE_EXIBE_ITEM_V varchar(1) := 'N';
	VAL_FONETICA_V bigint := 0;	
	IE_EXISTE_PROC bigint := 0;
	
	
  c RECORD;

BEGIN
	
		for c in (  select UPPER(SUBSTR(coalesce(c.nm_curto,(coalesce(d.ds_proc_exame,coalesce(SUBSTR(obter_nome_pf(c.cd_medico),1,255),coalesce(e.ds_especialidade,f.ds_grupo_proc))))),1,255)) ds,
						   c.nr_Seq_proc_interno
					  FROM agenda_int_area g, agenda_int_grupo_item c
LEFT OUTER JOIN proc_interno d ON (c.nr_seq_proc_interno = d.nr_sequencia)
LEFT OUTER JOIN especialidade_medica e ON (c.cd_especialidade = e.cd_especialidade)
LEFT OUTER JOIN ageint_grupo_proc f ON (c.nr_seq_grupo_proc = f.nr_sequencia)
WHERE g.nr_sequencia = NR_SEQ_AREA_P AND c.nr_seq_grupo = NR_SEQ_GRUPO_P ) loop
		
			select coalesce(MAX(1),0)
			  INTO STRICT PSEUDONIMO_V
			  from proc_interno_pseudo x 
			 where x.nr_Seq_proc_interno = c.nr_Seq_proc_interno
			   and upper(ds_pseudo_sem_acento) like UPPER('%'||DS_ITEM_P||'%');

			VAL_FONETICA_V := ageint_ret_item_fonetica_pck.return_cad_local();
		
			IF ((coalesce(DS_ITEM_P::text, '') = '') OR (UPPER(remover_acentuacao(c.ds)) like UPPER('%'||remover_acentuacao(DS_ITEM_P)||'%')) OR (PSEUDONIMO_V > 0)) THEN
				IE_EXIBE_ITEM_P_V := 'S';
			ELSE
				IE_EXIBE_ITEM_P_V := 'N';
			END IF;
			
			IF (VAL_FONETICA_V > 0) THEN
			
				select coalesce(MAX(1),0)
				  INTO STRICT FONETICA_V
				  from proc_interno_pseudo x 
				 where x.nr_Seq_proc_interno = c.nr_Seq_proc_interno 
				   and gera_fonetica(UPPER(ds_pseudo_sem_Acento),'S') like DS_ITEM_FONETICA_P;
			
				IF (gera_fonetica(UPPER(c.ds),'S') like DS_ITEM_FONETICA_P OR FONETICA_V > 0) THEN
					IE_EXIBE_ITEM_F_V := 'S';
				ELSE
					IE_EXIBE_ITEM_F_V := 'N';
				END IF;
			ELSE
				IE_EXIBE_ITEM_F_V := 'N';
			END IF;
			
			IF (IE_EXIBE_ITEM_F_V = 'S' OR IE_EXIBE_ITEM_P_V = 'S') THEN
				IE_EXIBE_ITEM_V := 'S';
			END IF;
			
		end loop;

		RETURN IE_EXIBE_ITEM_V;
	END;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_ret_item_fonetica_pck.valida_exibicao_item_section (DS_ITEM_P text, DS_ITEM_FONETICA_P text, NR_SEQ_GRUPO_P bigint, NR_SEQ_AREA_P bigint) FROM PUBLIC;