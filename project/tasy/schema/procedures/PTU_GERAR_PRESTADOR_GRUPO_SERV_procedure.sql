-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_prestador_grupo_serv ( nr_seq_endereco_p ptu_prestador_endereco.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

				
cd_grupo_serv_w			pls_prestador_grupo_serv.cd_grupo_servico%type;
nr_seq_prestador_w		ptu_prestador_endereco.nr_seq_prestador_end%type;
nr_seq_prest_medico_w		ptu_prestador_endereco.nr_seq_prest_medico%type;
qt_prest_med_grupo_serv_w	integer := 0;
qt_prest_grupo_end_w		integer := 0;
ie_tipo_prestador_w		ptu_prestador.ie_tipo_prestador%type;
ie_tipo_endereco_w		ptu_prestador_endereco.ie_tipo_endereco%type;
nr_seq_prest_end_w		pls_prestador_endereco.nr_sequencia%type;

-- Restringe por prestador
c01 CURSOR(nr_seq_prestador_pc	ptu_prestador_endereco.nr_seq_prestador_end%type) FOR
	SELECT	a.cd_grupo_servico,
		a.nr_sequencia nr_seq_prest_grupo_serv
	from	pls_prestador_grupo_serv a
	where	a.nr_seq_prestador	= nr_seq_prestador_pc
	and	coalesce(a.nr_seq_prest_end::text, '') = '';
	
-- Restringe por grupo médico
c02 CURSOR(nr_seq_prest_medico_pc	ptu_prestador_endereco.nr_seq_prest_medico%type) FOR
	SELECT	a.cd_grupo_servico ,
		a.nr_sequencia nr_seq_prest_grupo_serv
	from	pls_prestador_grupo_serv a,
		pls_prest_med_grupo_serv b
	where	a.nr_sequencia		= b.nr_seq_prest_grupo_serv
	and	b.nr_seq_prest_med	= nr_seq_prest_medico_pc
	and	coalesce(a.nr_seq_prest_end::text, '') = '';

-- Restringe por endereço
c03 CURSOR(nr_seq_prest_end_pc	pls_prestador_endereco.nr_sequencia%type) FOR
	SELECT	a.cd_grupo_servico,
		a.nr_sequencia nr_seq_prest_grupo_serv
	from	pls_prestador_grupo_serv a
	where	a.nr_seq_prest_end	= nr_seq_prest_end_pc;

BEGIN
select	max(coalesce(a.nr_seq_prestador_end,b.nr_seq_prestador)),
	max(a.nr_seq_prest_medico),
	max(b.ie_tipo_prestador),
	max(a.ie_tipo_endereco),
	max(a.nr_seq_prest_end)
into STRICT	nr_seq_prestador_w,
	nr_seq_prest_medico_w,
	ie_tipo_prestador_w,
	ie_tipo_endereco_w,
	nr_seq_prest_end_w
from	ptu_prestador b,
	ptu_prestador_endereco a
where	a.nr_seq_prestador	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_endereco_p;

if (nr_seq_prest_medico_w IS NOT NULL AND nr_seq_prest_medico_w::text <> '') then
	select	count(1)
	into STRICT	qt_prest_med_grupo_serv_w
	from	pls_prest_med_grupo_serv
	where	nr_seq_prest_med	= nr_seq_prest_medico_w;
end if;

if (nr_seq_prest_end_w IS NOT NULL AND nr_seq_prest_end_w::text <> '') then
	select	count(1)
	into STRICT	qt_prest_grupo_end_w
	from	pls_prestador_grupo_serv
	where	nr_seq_prest_end = nr_seq_prest_end_w;
end if;

if (nr_seq_prest_end_w IS NOT NULL AND nr_seq_prest_end_w::text <> '') and (qt_prest_grupo_end_w > 0) then
	-- Restringe por endereço
	for r_c03_w in c03( nr_seq_prest_end_w ) loop
		insert into ptu_prestador_grupo_serv(nr_sequencia, 				nr_seq_endereco, 			cd_grupo_servico,
			dt_atualizacao,				nm_usuario, 				dt_atualizacao_nrec,
			nm_usuario_nrec,			nr_seq_prest_grupo_serv)
		values (nextval('ptu_prestador_grupo_serv_seq'),	nr_seq_endereco_p, 			r_c03_w.cd_grupo_servico,
			clock_timestamp(), 				nm_usuario_p, 				clock_timestamp(),
			nm_usuario_p,				r_c03_w.nr_seq_prest_grupo_serv);	
	end loop;

elsif (nr_seq_prest_medico_w IS NOT NULL AND nr_seq_prest_medico_w::text <> '') and (qt_prest_med_grupo_serv_w > 0) then
	-- Restringe por grupo médico
	for r_c02_w in c02( nr_seq_prest_medico_w ) loop
		insert into ptu_prestador_grupo_serv(nr_sequencia,				nr_seq_endereco,			cd_grupo_servico,
			dt_atualizacao,				nm_usuario, 				dt_atualizacao_nrec,
			nm_usuario_nrec,			nr_seq_prest_grupo_serv)
		values (nextval('ptu_prestador_grupo_serv_seq'), 	nr_seq_endereco_p, 			r_c02_w.cd_grupo_servico,
			clock_timestamp(), 				nm_usuario_p, 				clock_timestamp(),
			nm_usuario_p,				r_c02_w.nr_seq_prest_grupo_serv);	
	end loop;

	-- Litoral, só deverá incluir os grupos do médico caso o mesmo esteja como profissional e possua o grupo cadastrado, 

	-- ou então nos casos onde não tem o medico informado, será inclusos todos os grupos do prestador, pois o médico é opcional
	
elsif (coalesce(nr_seq_prest_medico_w::text, '') = '') then
	-- Restringe por prestador
	for r_c01_w in c01( nr_seq_prestador_w ) loop
		insert into ptu_prestador_grupo_serv(nr_sequencia, 				nr_seq_endereco, 			cd_grupo_servico,
			dt_atualizacao,				nm_usuario, 				dt_atualizacao_nrec,
			nm_usuario_nrec,			nr_seq_prest_grupo_serv)
		values (nextval('ptu_prestador_grupo_serv_seq'),	nr_seq_endereco_p, 			r_c01_w.cd_grupo_servico,
			clock_timestamp(), 				nm_usuario_p, 				clock_timestamp(),
			nm_usuario_p,				r_c01_w.nr_seq_prest_grupo_serv);	
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_prestador_grupo_serv ( nr_seq_endereco_p ptu_prestador_endereco.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
