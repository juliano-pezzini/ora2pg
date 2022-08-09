-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_lote_imp_unimed ( nm_usuario_p text, nr_seq_lote_p bigint ) AS $body$
DECLARE

			
nr_sequencia_w		bigint;
ds_tipo_prestador_w	varchar(255);
qt_inconsistencias_w	integer	:= 0;
qt_inconsist_coop_w	integer	:= 0;
qt_divergencias_coop_w	integer	:= 0;
cd_tipo_pessoa_w	bigint;
nr_seq_tipo_coop_w	bigint;
ie_divergente_w		integer;

ds_razao_social_w	varchar(255);
nm_fantasia_w		varchar(255);
ds_bairro_w		varchar(255);
ds_endereco_w		varchar(255);
sg_estado_w		pls_w_import_cad_unimed.sg_estado%type;
cd_cep_w		varchar(15);
ds_email_w		varchar(255);
ds_site_w		varchar(255);
ds_cidade_w		varchar(40);
cd_cgc_w		varchar(14);
nr_inscr_estadual_w	varchar(20);
nr_inscr_municipal_w	varchar(20);
cd_ans_w		varchar(20);
cd_cgc_coop_w		varchar(14);
cd_cgc_outorgante_w	varchar(14);
cd_estabelecimento_w	smallint;
		
C01 CURSOR FOR
SELECT	nr_sequencia,
	ds_tipo_prestador,
	ds_razao_social,
	nm_fantasia,
	ds_bairro,		
	ds_endereco,		
	sg_estado,		
	cd_cep,		
	ds_email,		
	ds_site,
	ds_cidade,
	cd_cgc,
	nr_inscr_estadual,
	nr_inscr_municipal,
	cd_ans	
from	pls_w_import_cad_unimed
where	nr_seq_lote	= nr_seq_lote_p;
		

BEGIN

select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	pls_lote_importacao_unimed a
where	a.nr_sequencia	= nr_seq_lote_p;

select	max(cd_cgc_outorgante)
into STRICT	cd_cgc_outorgante_w
from	pls_outorgante a
where	a.cd_estabelecimento	= cd_estabelecimento_w;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	ds_tipo_prestador_w,
	ds_razao_social_w,
	nm_fantasia_w,
	ds_bairro_w,		
	ds_endereco_w,		
	sg_estado_w,		
	cd_cep_w,		
	ds_email_w,		
	ds_site_w,
	ds_cidade_w,
	cd_cgc_w,
	nr_inscr_estadual_w,
	nr_inscr_municipal_w,
	cd_ans_w;		
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	delete from	pls_cad_unimed_inconsist
	where		nr_seq_cad_unimed	= nr_sequencia_w;
	
	/*########################
	#	INCONSISTENCIAS	         #	
	########################*/
	
	
	select	max(cd_tipo_pessoa)
	into STRICT	cd_tipo_pessoa_w
	from	tipo_pessoa_juridica
	where	ie_comercial_ops	= 'O';
	
	if (coalesce(cd_tipo_pessoa_w::text, '') = '') then
		CALL pls_gravar_inc_unimed(1, obter_desc_expressao(779625), nr_sequencia_w, nm_usuario_p);
		qt_inconsistencias_w	:= qt_inconsistencias_w + 1;
		qt_inconsist_coop_w	:= qt_inconsist_coop_w + 1;
	end if;
	
	select	max(c.nr_sequencia)
	into STRICT	nr_seq_tipo_coop_w
	from	pls_tipo_cooperativa	c
	where	upper(c.ds_tipo) = upper(ds_tipo_prestador_w)
	and	c.ie_situacao	= 'A';
				
	if (coalesce(nr_seq_tipo_coop_w::text, '') = '') then
		CALL pls_gravar_inc_unimed(2, wheb_mensagem_pck.get_texto(1180695, 'DS=' || ds_tipo_prestador_w), nr_sequencia_w, nm_usuario_p);
		qt_inconsistencias_w	:= qt_inconsistencias_w + 1;
		qt_inconsist_coop_w	:= qt_inconsist_coop_w + 1;
	end if;			
	
	/*#######################
	#	DIVERGENCIAS	      #	
	#######################*/

	
	/* So pode fazer essas consistencias se achou a pessoa juridica com o mesmo CGC */

	
	select	max(cd_cgc)
	into STRICT	cd_cgc_coop_w
	from	pessoa_juridica a
	where	a.cd_cgc	= cd_cgc_w;
	
	if (cd_cgc_coop_w IS NOT NULL AND cd_cgc_coop_w::text <> '') and (cd_cgc_coop_w <> cd_cgc_outorgante_w) then
	
		/* ====== 	RAZAO SOCIAL      ======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_razao_social	= ds_razao_social_w;

		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(761645)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	NOME FANTASIA      ======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	nm_fantasia	= nm_fantasia_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(646424)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	ENDERECO	     ======*/
	
		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_endereco	= ds_endereco_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(289232)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	BAIRRO	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_bairro	= ds_bairro_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(284200)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	ESTADO	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	sg_estado	= sg_estado_w;

		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(289525)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	CEP	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	cd_cep	= cd_cep_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(284796)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	E-MAIL	======*/
	
		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_email	= ds_email_w;
			
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(289120)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;

		/* ====== 	SITE	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_site_internet	= ds_site_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(298556)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;	
		
		/* ====== 	CIDADE       ======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	ds_municipio	= ds_cidade_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(302837)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	CNPJ	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	cd_cgc	= cd_cgc_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(285188)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	INSCRICAO ESTADUAL     ======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	coalesce(nr_inscricao_estadual,0)	= coalesce(nr_inscr_estadual_w,0);
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(681330)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	INSCRICAO MUNICIPAL      ======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	coalesce(nr_inscricao_municipal,0)	= coalesce(nr_inscr_municipal_w,0);
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(350509)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;
		
		/* ====== 	ANS	======*/

		select	count(*)
		into STRICT	ie_divergente_w
		from	pessoa_juridica
		where	cd_ans	= cd_ans_w;
		
		if (ie_divergente_w = 0) then
			CALL pls_gravar_inc_unimed(3, wheb_mensagem_pck.get_texto(1023973, 'DS_INF=' || obter_desc_expressao(283518)), nr_sequencia_w, nm_usuario_p);
			qt_divergencias_coop_w	:= qt_divergencias_coop_w +1;
		end if;	
	end if;

	/* ====== 	Grava  ou limpa as inconsistencias das Cooperativas    ======*/

	if (qt_divergencias_coop_w > 0) and (qt_inconsist_coop_w = 0) then
		update	pls_w_import_cad_unimed
		set	ie_tipo_inconsistencia	= '3'
		where	nr_sequencia	= nr_sequencia_w;
	end if;

	if (qt_inconsist_coop_w	> 0) and (qt_divergencias_coop_w = 0) then
		update	pls_w_import_cad_unimed
		set	ie_tipo_inconsistencia	= '12'
		where	nr_sequencia	= nr_sequencia_w;
	end if;	
	
	if (qt_inconsist_coop_w	= 0) and (qt_divergencias_coop_w	= 0) then
		update	pls_w_import_cad_unimed
		set	ie_tipo_inconsistencia	= ''
		where	nr_sequencia	= nr_sequencia_w;
	end if;

	qt_inconsist_coop_w	:= 0;
	qt_divergencias_coop_w	:= 0;
	
	end;
end loop;
close C01;

/* ====== 	Fecha o lote caso nao haja inconsistencias     ======*/

if (qt_inconsistencias_w = 0) then	
	update	pls_lote_importacao_unimed
	set	dt_consistente	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_lote_imp_unimed ( nm_usuario_p text, nr_seq_lote_p bigint ) FROM PUBLIC;
