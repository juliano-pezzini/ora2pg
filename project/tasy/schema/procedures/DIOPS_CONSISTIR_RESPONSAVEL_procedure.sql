-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_consistir_responsavel ( nr_seq_periodo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nm_responsavel_w		varchar(80);
cd_responsavel_w		varchar(20);
nr_num_registro_w		varchar(20);
cd_cgc_w			varchar(14);
nr_cpf_w			varchar(11);
cd_pessoa_fisica_w		varchar(10);
ie_tipo_responsavel_w		varchar(2);
	
C01 CURSOR FOR 
	SELECT	cd_pessoa_fisica, 
		obter_cpf_pessoa_fisica(cd_pessoa_fisica), 
		cd_cgc, 
		nr_num_registro, 
		ie_tipo_responsavel 
	from	w_diops_cad_responsavel 
	where	nr_seq_periodo	= nr_seq_periodo_p;


BEGIN 
open C01;
loop 
fetch C01 into	 
	cd_pessoa_fisica_w, 
	nr_cpf_w, 
	cd_cgc_w, 
	nr_num_registro_w, 
	ie_tipo_responsavel_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		nm_responsavel_w	:= obter_nome_pf(cd_pessoa_fisica_w);
		cd_responsavel_w	:= 'PF - ' || cd_pessoa_fisica_w;
	elsif (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		nm_responsavel_w	:= obter_razao_social(cd_cgc_w);
		cd_responsavel_w	:= 'PJ - ' || cd_cgc_w;
	end if;
 
	/* 1 - Número do registro do responsável não informado */
 
	if (coalesce(nr_num_registro_w::text, '') = '') then 
		CALL diops_gravar_inconsistencia(	nr_seq_periodo_p, 
						1, 
						cd_responsavel_w || ' - ' || ie_tipo_responsavel_w || ' - ' || nm_responsavel_w, 
						cd_pessoa_fisica_w, 
						nm_usuario_p, 
						cd_estabelecimento_p);
	end if;
	 
	/* 2 - Pessoa física sem a informação do CPF */
 
	if (coalesce(nr_cpf_w::text, '') = '') and (coalesce(cd_cgc_w::text, '') = '') then 
		CALL diops_gravar_inconsistencia(	nr_seq_periodo_p, 
						2, 
						cd_responsavel_w || ' - ' || ie_tipo_responsavel_w || ' - ' || nm_responsavel_w, 
						cd_pessoa_fisica_w, 
						nm_usuario_p, 
						cd_estabelecimento_p);	
	end if;
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_consistir_responsavel ( nr_seq_periodo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
