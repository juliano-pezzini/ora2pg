-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_cop_relat_prest_web ( nm_usuario_p text) AS $body$
DECLARE

 
qt_registro_relat_w	bigint := 0;
qt_dominio_w		bigint;
nr_seq_grupo_w		bigint;
nr_seq_relat_w		bigint;


BEGIN 
 
select	count(1) 
 into STRICT	qt_dominio_w 
 from 	valor_dominio 
 where 	cd_dominio = 3003 
  and	vl_dominio = '26';
 
if (qt_dominio_w = 1) then 
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_grupo_w 
	from	pls_regra_relat_grupo 
	where	ie_grupo = 26;
 
	if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then 
 
		select	count(1) 
		into STRICT	qt_registro_relat_w 
		from	pls_regra_relatorio a, 
			relatorio b 
		where	a.nr_seq_grupo = nr_seq_grupo_w 
		and	a.nr_seq_relatorio = b.nr_sequencia 
		and	b.cd_relatorio = 729 
		and	b.cd_classif_relat = 'WPLS';
		 
	else 
		qt_registro_relat_w := 0;
		 
		select	nextval('pls_regra_relat_grupo_seq') 
		into STRICT	nr_seq_grupo_w 
		;
		 
		insert	into pls_regra_relat_grupo(nr_sequencia, ie_grupo, dt_atualizacao, 
						  nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec) 
					  values (nr_seq_grupo_w, 26, clock_timestamp(), 
						  nm_usuario_p, clock_timestamp(), nm_usuario_p);
						  
	end if;
 
	if (qt_registro_relat_w = 0) then 
		select 	max(nr_sequencia) 
		into STRICT	nr_seq_relat_w 
		from	relatorio 
		where  cd_relatorio = 729 
		and	cd_classif_relat = 'WPLS';
		 
		if (nr_seq_relat_w IS NOT NULL AND nr_seq_relat_w::text <> '') then 
		 
			insert	into  pls_regra_relatorio(nr_sequencia, nr_seq_grupo, dt_atualizacao, 
							  nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
							  nr_seq_relatorio) 
						  values (nextval('pls_regra_relat_grupo_seq'), nr_seq_grupo_w, clock_timestamp(), 
							  nm_usuario_p, clock_timestamp(), nm_usuario_p, 
							  nr_seq_relat_w);
 
		end if;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_cop_relat_prest_web ( nm_usuario_p text) FROM PUBLIC;

