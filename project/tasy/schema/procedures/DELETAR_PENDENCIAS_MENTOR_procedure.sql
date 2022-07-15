-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_pendencias_mentor ( nm_tabela_p text, nm_atributo_p text, nr_sequencia_P text) AS $body$
DECLARE

 
ds_comando_w		varchar(2000);
nm_campo_w			varchar(50);
nm_int_ref_w		varchar(50);
ie_executou_aut_w	varchar(1);
nr_seq_pend_pac_acao_w	bigint;
vl_atributo_w		bigint;
nm_atributo_ref_w	varchar(50);
ds_mensagem_w		varchar(255);
ds_sep_bv_w			varchar(30)	:= obter_separador_bv;
ds_parametros_w		varchar(32000);


BEGIN 
 
ie_executou_aut_w := 'N';
 
if (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '') and (nr_sequencia_P IS NOT NULL AND nr_sequencia_P::text <> '') then 
	 
		 
		select 	coalesce(max(a.nm_integridade_referencial),null), 
				coalesce(max(b.nm_atributo),null) 
		into STRICT	nm_int_ref_w, 
				nm_atributo_ref_w 
		from	integridade_referencial a, 
				integridade_atributo b 
		where	a.nm_tabela = 'GQA_PENDENCIA_PAC' 
		and		a.nm_tabela = b.nm_tabela 
		and		upper(a.nm_tabela_referencia) = upper(nm_tabela_p) 
		and		upper(b.nm_atributo_ref) = upper(nm_atributo_p);
		 
			 
		if (nm_int_ref_w IS NOT NULL AND nm_int_ref_w::text <> '') and (nm_atributo_ref_w IS NOT NULL AND nm_atributo_ref_w::text <> '')then	 
			 
										 
			vl_atributo_w := Obter_valor_Dinamico_bv('select	nvl(max(nr_sequencia),0)'|| 
										' from gqa_pendencia_pac'|| 
										' where '||nm_atributo_ref_w||' = :nr_sequencia_p ', 'nr_sequencia_P='||nr_sequencia_P, vl_atributo_w);	
 
	 
			if (vl_atributo_w > 0 ) then					 
				 
				SELECT	max(SUBSTR(obter_informacoes_pendencia(nr_sequencia),1,255))		 
				INTO STRICT	ie_executou_aut_w					 
				FROM	GQA_PEND_PAC_ACAO 
				WHERE	nr_seq_pend_pac = vl_atributo_w;					
 
				 
				if (coalesce(ie_executou_aut_w,'XPTO') = 'N') then 
 
						ds_mensagem_w := wheb_mensagem_pck.get_texto(444095);
					 
						ds_comando_w :=	' update gqa_pend_pac_acao set dt_encerramento = sysdate , dt_justificativa = sysdate, DS_JUSTIFICATIVA = :ds_justificativa where nr_seq_pend_pac = :vl_atributo';
						 
						ds_parametros_w:=	'ds_justificativa='||ds_mensagem_w||ds_sep_bv_w|| 
					'vl_atributo='||vl_atributo_w||ds_sep_bv_w;
						 
						 
						CALL Exec_sql_Dinamico_bv('Tasy', ds_comando_w,ds_parametros_w);
						 
						commit;	
				end if;
				 
			end if;
			 
		end if;
		 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_pendencias_mentor ( nm_tabela_p text, nm_atributo_p text, nr_sequencia_P text) FROM PUBLIC;

