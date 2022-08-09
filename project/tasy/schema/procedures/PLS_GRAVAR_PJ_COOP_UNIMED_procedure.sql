-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_pj_coop_unimed ( nm_usuario_p text, nr_seq_lote_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_sequencia_w			bigint;
dt_atualizacao_w		timestamp;
nm_usuario_w			varchar(15);
dt_atualizacao_nrec_w		timestamp;
nm_usuario_nrec_w		varchar(15);
ds_razao_social_w		varchar(255);
nm_fantasia_w			varchar(255);
ds_endereco_w			varchar(4000);
ds_bairro_w			varchar(255);
ds_cidade_w			varchar(255);
sg_estado_w 			pls_w_import_cad_unimed.sg_estado%type;
cd_cep_w	        	varchar(15);
cd_cgc_w	        	varchar(14);
nr_inscr_estadual_w     	varchar(30);
nr_inscr_municipal_w		varchar(30);
cd_ans_w	        	varchar(255);
ds_email_w			varchar(255);
nr_telefone_1_w			varchar(40);
ds_site_w	        	varchar(255);
cd_complexo_w           	varchar(10);
cd_tipo_pessoa_w		smallint;
qt_registro_w			varchar(14);
ds_tipo_prestador_w		varchar(255);
nr_seq_tipo_coop_w		bigint;
ds_inconsistencia_w		varchar(2000)	:= '';
ie_tipo_inconsistencia_w	integer	:= 0;

C01 CURSOR FOR
SELECT	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	substr(ds_razao_social,1,80),
	substr(nm_fantasia,1,80),
	ds_tipo_prestador,
	substr(ds_endereco,1,40),
	substr(ds_bairro,1,40),
	substr(ds_cidade,1,40),
	sg_estado,
	cd_cep,
	cd_cgc,
	substr(nr_inscr_estadual,1,20),
	substr(nr_inscr_municipal,1,20),
	substr(cd_ans,1,20),
	substr(ds_email,1,60),
	substr(nr_telefone_1,1,15),
	substr(ds_site,1,40),
	cd_complexo
from	pls_w_import_cad_unimed
where	nr_seq_lote	= nr_seq_lote_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	dt_atualizacao_w,
	nm_usuario_w,
	dt_atualizacao_nrec_w,
	nm_usuario_nrec_w,
	ds_razao_social_w,
	nm_fantasia_w,
	ds_tipo_prestador_w,
	ds_endereco_w,
	ds_bairro_w,
	ds_cidade_w,
	sg_estado_w,
	cd_cep_w,
	cd_cgc_w,
	nr_inscr_estadual_w,
	nr_inscr_municipal_w,
	cd_ans_w,
	ds_email_w,
	nr_telefone_1_w,
	ds_site_w,
	cd_complexo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	begin

	select	count(*)
	into STRICT	qt_registro_w
	from	pessoa_juridica a
	where	a.cd_cgc	= to_Char(cd_cgc_w);

	if (qt_registro_w = 0) then

		select	max(cd_tipo_pessoa)
		into STRICT	cd_tipo_pessoa_w
		from	tipo_pessoa_juridica
		where	ie_comercial_ops	= 'O';

		if (cd_tipo_pessoa_w IS NOT NULL AND cd_tipo_pessoa_w::text <> '') then
			insert into	pessoa_juridica(nm_usuario, dt_atualizacao, nm_usuario_nrec,
				dt_atualizacao_nrec, ds_razao_social, nm_fantasia,
				ds_endereco, ds_bairro, ds_municipio,
				sg_estado, cd_cep, cd_cgc,
				nr_inscricao_estadual, nr_inscricao_municipal, cd_ans,
				ds_email, nr_telefone, ds_site_internet,
				ie_prod_fabric, ie_situacao, cd_tipo_pessoa)
			values (nm_usuario_p, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), ds_razao_social_w, nm_fantasia_w,
				ds_endereco_w, ds_bairro_w, ds_cidade_w,
				sg_estado_w, cd_cep_w, cd_cgc_w,
				nr_inscr_estadual_w, nr_inscr_municipal_w, cd_ans_w,
				ds_email_w, nr_telefone_1_w, ds_site_w,
				'N', 'A', cd_tipo_pessoa_w);
		end if;
	end if;

	select	count(*)
	into STRICT	qt_registro_w
	from	pls_congenere	a
	where	a.cd_cgc	= cd_cgc_w;

	if (qt_registro_w = 0) then

		select	max(c.nr_sequencia)
		into STRICT	nr_seq_tipo_coop_w
		from	pls_tipo_cooperativa	c
		where	upper(c.ds_tipo) = upper(ds_tipo_prestador_w);

		if (nr_seq_tipo_coop_w IS NOT NULL AND nr_seq_tipo_coop_w::text <> '') then

			insert into pls_congenere(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, cd_cgc,
				ie_situacao, cd_cooperativa, dt_inclusao, nr_seq_tipo_coop,
				cd_estabelecimento, ie_tipo_congenere,ie_situacao_atend,
				ie_relatorio_a100)
			values (nextval('pls_congenere_seq'), clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, cd_cgc_w,
				'A', cd_complexo_w, clock_timestamp(), nr_seq_tipo_coop_w,
				cd_estabelecimento_p, 'CO','A',
				'N');
		end if;
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
-- REVOKE ALL ON PROCEDURE pls_gravar_pj_coop_unimed ( nm_usuario_p text, nr_seq_lote_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
