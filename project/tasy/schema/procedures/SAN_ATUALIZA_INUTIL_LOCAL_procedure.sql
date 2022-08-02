-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_atualiza_inutil_local ( sql_item_p text, nr_seq_inutilizacao_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


nm_pasta_w			varchar(3) := 's';
nr_seq_transfusao_w		bigint;
nr_seq_emp_saida_w		bigint;
nr_seq_reserva_w		bigint;
nr_seq_itens_emprestado_w	bigint;
nr_seq_producao_w		bigint;
nr_seq_estoque_w		bigint;			
nr_seq_exame_w			bigint;			
nr_seq_producao_pasta_w		bigint;
nr_seq_emp_ent_w		bigint;
ie_hemocomp_receb_estoque_w	varchar(1);
nr_seq_prod_w			varchar(255);
nr_pos_virgula_w		bigint;	
ds_lista_itens_w		dbms_sql.varchar2_table;
		
BEGIN

ie_hemocomp_receb_estoque_w := obter_param_usuario(450, 230, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_p, ie_hemocomp_receb_estoque_w);

ds_lista_itens_w := obter_lista_string(sql_item_p, ',');

for i in ds_lista_itens_w.first..ds_lista_itens_w.last loop
	begin
	nr_seq_prod_w := obter_somente_numero(ds_lista_itens_w(i));
		
	select 	coalesce(b.nr_seq_emp_ent,0),
		coalesce(b.nr_seq_transfusao,0),
		coalesce(b.nr_seq_emp_saida,0),
		coalesce((	select max(nr_sequencia)
			from	SAN_RESERVA_PROD x
			where	x.nr_seq_producao = b.nr_sequencia),0) nr_seq_reserva,		
		coalesce((	select  max(c.nr_sequencia)
			from     san_producao c
			where     c.nr_sequencia = b.nr_sequencia
			and       (c.dt_inicio_prod_emprestimo IS NOT NULL AND c.dt_inicio_prod_emprestimo::text <> '')),0) nr_seq_itens_emprestado,
		coalesce((	select  max(x.nr_sequencia)
			from	san_producao x
			where	x.nr_sequencia = b.nr_sequencia),0) nr_seq_producao,
		coalesce((	select  max(nr_sequencia)
			from	san_producao_consulta_v a
			where	coalesce(a.nr_seq_emp_saida::text, '') = ''
			and	coalesce(a.nr_seq_transfusao::text, '') = ''
			and	a.nr_sequencia = b.nr_sequencia
			and	a.cd_estabelecimento = cd_estabelecimento_p
			and	not exists (select	1
						from	san_envio_derivado_val x,
						san_envio_derivado z
						where	z.nr_sequencia	= x.nr_seq_envio
						and	x.nr_seq_producao	= a.nr_sequencia
						and	x.dt_recebimento is  null)
			and	not exists (select	1
						from	san_reserva_prod x
						where	x.nr_seq_producao = a.nr_sequencia
						and	x.ie_status <> 'N')
			and	not exists (select	1
						from	san_controle_qualidade x,
							san_controle_qual_prod y
						where	x.nr_sequencia = y.nr_seq_qualidade
						and	y.nr_seq_producao = a.nr_sequencia
						and	coalesce(x.dt_liberacao::text, '') = '')
			and   a.ie_pai_reproduzido <> 'S'
			and   a.nr_sequencia = b.nr_sequencia
			and	(	(ie_hemocomp_receb_estoque_w = 'N') or
				(	(ie_hemocomp_receb_estoque_w = 'S') and
					(	(a.dt_recebimento IS NOT NULL AND a.dt_recebimento::text <> '' AND dt_liberacao_bolsa IS NOT NULL AND dt_liberacao_bolsa::text <> '') or ((a.nr_seq_emp_ent IS NOT NULL AND a.nr_seq_emp_ent::text <> '') and (coalesce(a.dt_inicio_prod_emprestimo::text, '') = '' or (a.dt_fim_prod_emprestimo IS NOT NULL AND a.dt_fim_prod_emprestimo::text <> '')))
					)
				)
			)),0) nr_seq_estoque,
		coalesce((	select	max(k.nr_sequencia)
			from	san_producao k
			where	k.nr_sequencia = b.nr_sequencia
			and	(k.dt_fim_producao IS NOT NULL AND k.dt_fim_producao::text <> '')
			and	(k.dt_recebimento IS NOT NULL AND k.dt_recebimento::text <> '')
			and	coalesce(k.dt_conferencia::text, '') = ''),0) nr_seq_exame,
		b.nr_sequencia
	into STRICT	nr_seq_emp_ent_w,
		nr_seq_transfusao_w,
		nr_seq_emp_saida_w,
		nr_seq_reserva_w,
		nr_seq_itens_emprestado_w,
		nr_seq_producao_pasta_w,
		nr_seq_estoque_w,
		nr_seq_exame_w,
		nr_seq_producao_w
	from   san_producao_v b
	where  b.nr_sequencia = nr_seq_prod_w;

	if (nr_seq_emp_saida_w > 0) then
		nm_pasta_w := 'S';
	elsif (nr_seq_itens_emprestado_w > 0) then
		nm_pasta_w := 'IE';
	elsif (nr_seq_transfusao_w > 0) then	
		nm_pasta_w := 'T';
	elsif (nr_seq_reserva_w > 0) then	
		nm_pasta_w := 'R';
	elsif (nr_seq_estoque_w > 0) then
		nm_pasta_w := 'Q';	
	elsif (nr_seq_exame_w > 0 ) then
		nm_pasta_w := 'E';
	elsif (nr_seq_emp_ent_w > 0) then
		nm_pasta_w := 'EE';	
	elsif (nr_seq_producao_w > 0) then
		nm_pasta_w := 'P';		
	end if;
	
	update 	san_producao
	set	nr_seq_inutil 		= nr_seq_inutilizacao_p,
		ie_local_inutilizacao	= nm_pasta_w,
		dt_inutilizacao		= clock_timestamp(),
		nm_usuario_inut		= wheb_usuario_pck.get_nm_usuario
	where	nr_sequencia		= nr_seq_producao_w;	

	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_atualiza_inutil_local ( sql_item_p text, nr_seq_inutilizacao_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

