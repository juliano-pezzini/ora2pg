-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_interf_i012_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) AS $body$
DECLARE



ds_arquivo_w		varchar(4000);
ds_compl_arquivo_w	varchar(4000);
ds_linha_w		varchar(8000);
nr_linha_w		bigint := qt_linha_p;
nr_seq_registro_w		bigint := nr_sequencia_p;
sep_w			varchar(1) := '|';
tp_registro_w		varchar(15) := 'I012';
nr_seq_regra_sped_w	ctb_sped_controle.nr_seq_regra_sped%type;
nr_livro_w		ctb_livro_auxiliar.nr_livro%type;
nr_seq_livro_w		ctb_livro_auxiliar.nr_sequencia%type;
ds_livro_w		ctb_livro_auxiliar.ds_livro%type;
cd_conta_contabil_w	ctb_livro_aux_conta.cd_conta_contabil%type;
cd_conta_apres_w		conta_contabil.cd_classificacao%type;
ie_apres_conta_ctb_w	ctb_regra_sped.ie_apres_conta_ctb%type;
nr_seq_cont_principal_w ctb_sped_controle.nr_seq_cont_principal%type;
ie_forma_escrituracao_w ctb_regra_sped.ie_forma_escrituracao%type;

c01 CURSOR FOR
SELECT DISTINCT
	nr_sequencia,
	nr_livro,
	ds_livro
FROM (SELECT
	b.nr_sequencia,
	b.nr_livro,
	b.ds_livro
FROM
	ctb_regra_sped_livro_aux a,
	ctb_livro_auxiliar b
WHERE
	a.nr_seq_livro_aux = b.nr_sequencia
	AND a.nr_seq_regra_sped = nr_seq_regra_sped_w

UNION ALL
  --Livros auxiliares (A) que possuem registros do livro Resumido.
SELECT
	b.nr_sequencia,
	b.nr_livro,
	b.ds_livro
FROM
	ctb_regra_sped_livro_aux a,
	ctb_livro_auxiliar b,
	ctb_sped_controle c
WHERE
	a.nr_seq_livro_aux = b.nr_sequencia
	AND a.nr_seq_regra_sped = c.nr_seq_regra_sped
	and c.nr_seq_cont_principal = nr_seq_controle_p) alias0;
	
c02 CURSOR FOR
SELECT	b.cd_conta_contabil
from	ctb_livro_auxiliar a,
	ctb_livro_aux_conta b
where 	b.nr_seq_livro = a.nr_sequencia
and 	b.nr_seq_livro = nr_seq_livro_w;


BEGIN
	
select 	max(a.nr_seq_regra_sped),
	max(a.nr_seq_cont_principal)
into STRICT	nr_seq_regra_sped_w,
        nr_seq_cont_principal_w
from	ctb_sped_controle a
where	a.nr_sequencia  = nr_seq_controle_p;

select	coalesce(max(a.ie_apres_conta_ctb),'CD'),
        max(a.ie_forma_escrituracao)
into STRICT	ie_apres_conta_ctb_w,
        ie_forma_escrituracao_w
from	ctb_regra_sped a
where	a.nr_sequencia	= nr_seq_regra_sped_w;


open C01;
loop
fetch C01 into
	nr_seq_livro_w,
	nr_livro_w,
	ds_livro_w;	
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	
	tp_registro_w	:= 'I012';
	ds_linha_w	:= substr(	sep_w || tp_registro_w 				||
					sep_w || nr_livro_w			 	|| 
					sep_w || ds_livro_w	 			|| 
					sep_w || 0		 			|| 
					sep_w || ''	 				|| sep_w,1,8000);
	
	ds_arquivo_w		:= substr(ds_linha_w,1,4000);
	ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
	nr_seq_registro_w	:= nr_seq_registro_w + 1;
	nr_linha_w		:= nr_linha_w + 1;	
	insert into ctb_sped_registro(
		nr_sequencia,
		ds_arquivo,                     
		dt_atualizacao,                 
		nm_usuario,                     
		dt_atualizacao_nrec,            
		nm_usuario_nrec,                
		nr_seq_controle_sped,           
		ds_arquivo_compl,               
		cd_registro,
		nr_linha)
	values (	nr_seq_registro_w,
		ds_arquivo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		ds_compl_arquivo_w,
		tp_registro_w,
		nr_linha_w);
		
	tp_registro_w	:= 'I015';
	open C02;
	loop
	fetch C02 into
		cd_conta_contabil_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		cd_conta_apres_w	:= cd_conta_contabil_w;
		
		if (ie_apres_conta_ctb_w = 'CL') then
			begin
			cd_conta_apres_w	:= substr(ctb_obter_classif_conta(cd_conta_contabil_w,null,dt_fim_p),1,40);
			end;
		elsif (ie_apres_conta_ctb_w = 'CP') then
			begin
			cd_conta_apres_w	:= substr(ctb_obter_classif_conta(cd_conta_contabil_w,null,dt_fim_p),1,40);
			cd_conta_apres_w	:= substr(replace(cd_conta_apres_w,'.',''),1,40);
			end;
		end if;
		
		ds_linha_w	:= substr(	sep_w || tp_registro_w  			||
						sep_w || cd_conta_apres_w			|| sep_w,1,8000);
	
		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_compl_arquivo_w	:= substr(ds_linha_w,4001,4000);
		nr_seq_registro_w	:= nr_seq_registro_w + 1;
		nr_linha_w		:= nr_linha_w + 1;
		
		insert into ctb_sped_registro(
			nr_sequencia,
			ds_arquivo,                     
			dt_atualizacao,                 
			nm_usuario,                     
			dt_atualizacao_nrec,            
			nm_usuario_nrec,                
			nr_seq_controle_sped,           
			ds_arquivo_compl,               
			cd_registro,
			nr_linha)
		values (	nr_seq_registro_w,
			ds_arquivo_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			ds_compl_arquivo_w,
			tp_registro_w,
			nr_linha_w);
			end;
	end loop;
	close C02;
	
	end;
end loop;
close C01;

commit;
qt_linha_p	:= nr_linha_w;
nr_sequencia_p	:= nr_seq_registro_w;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_interf_i012_ecd ( nr_seq_controle_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint) FROM PUBLIC;
