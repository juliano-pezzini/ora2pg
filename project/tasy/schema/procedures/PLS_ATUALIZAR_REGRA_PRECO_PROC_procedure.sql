-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_regra_preco_proc ( nr_seq_regra_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* ie_opcao_p 
	'A' - Atualizar 
	'D' - Deletar 
*/
 
 
nr_seq_regra_w			bigint	:= null;
nr_seq_regra_proc_ref_w		bigint;
ds_instrucao_w			varchar(32767);
ret_w					bigint;
nm_atributo_w			Tabela_Atributo.nm_atributo%type;WITH RECURSIVE cte AS (


 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia,a.nr_seq_regra_proc_ref 
	from	pls_regra_preco_proc	a WHERE a.nr_sequencia in (SELECT	x.nr_sequencia 
					from	pls_regra_preco_proc x 
					where	x.nr_sequencia	= nr_seq_regra_p)
  UNION ALL

 
 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia,a.nr_seq_regra_proc_ref 
	from	pls_regra_preco_proc	a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_regra_proc_ref)

) SELECT * FROM cte;
;WITH RECURSIVE cte AS (

	
C02 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	pls_regra_preco_proc	a WHERE a.nr_sequencia in (SELECT	x.nr_sequencia 
					from	pls_regra_preco_proc x 
					where	x.nr_seq_regra_proc_ref	= nr_seq_regra_p)
  UNION ALL

	 
C02 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	pls_regra_preco_proc	a JOIN cte c ON (c.prior nr_sequencia = a.nr_seq_regra_proc_ref)

) SELECT * FROM cte ORDER BY  level desc;
;
	
C03 CURSOR FOR 
	SELECT	a.nm_atributo 
	From	Tabela_Atributo	a 
	where	upper(a.nm_tabela) = 'PLS_REGRA_PRECO_PROC' 
	and		(a.NR_SEQ_APRESENT IS NOT NULL AND a.NR_SEQ_APRESENT::text <> '') 
	and		upper(ie_tipo_atributo) not in ('FUNCTION', 'VISUAL') 
	and		upper(a.nm_atributo) not in ('NR_SEQUENCIA','CD_OPERADORA_EMPRESA','NR_SEQ_REGRA_PROC_REF','DS_REGRA','NR_SEQ_RP_COMBINADA','IE_TIPO_TABELA') 
	order by 1;


BEGIN 
if (ie_opcao_p = 'A') then 
	ds_instrucao_w := 'update pls_regra_preco_proc set' || chr(13);
	 
	open C03;
	loop 
	fetch C03 into	 
		nm_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		ds_instrucao_w := ds_instrucao_w || nm_atributo_w || ' = (select ' || nm_atributo_w || ' from pls_regra_preco_proc where nr_sequencia = #seq# ), ' || chr(13);
	end loop;
	close C03;
	 
	ds_instrucao_w := substr(ds_instrucao_w,1,length(ds_instrucao_w)-3) || chr(13);
	ds_instrucao_w := ds_instrucao_w || 'where nr_sequencia	= #seqregra# ';
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_regra_w, 
		nr_seq_regra_proc_ref_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		if (nr_seq_regra_proc_ref_w IS NOT NULL AND nr_seq_regra_proc_ref_w::text <> '') then 
			ret_w := executar_sql_dinamico(replace(replace(ds_instrucao_w, '#seqregra#', nr_seq_regra_w), '#seq#', nr_seq_regra_proc_ref_w), ret_w);
		end if;
	end;
	end loop;
	close C01;
 
elsif (ie_opcao_p = 'D') then 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
			delete	FROM pls_regra_preco_proc 
			where	nr_sequencia	= nr_seq_regra_w;
		end;
	end loop;
	close C02;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_regra_preco_proc ( nr_seq_regra_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
