-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_contestacao ( nr_seq_fatura_p bigint, nr_seq_lote_contest_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
ie_valor_base_w			varchar(2)	:= null;
ie_tipo_w			varchar(1);
vl_apresentado_w		double precision;
vl_glosa_w			double precision;
vl_liberado_w			double precision;
vl_calulado_w			double precision;
vl_item_w			double precision;
qt_apresentada_w		double precision;
qt_glosa_w			double precision;
qt_liberada_w			double precision;
nr_seq_lote_contest_w		bigint	:= null;
nr_seq_contestacao_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_contest_proc_w		bigint;
nr_seq_contest_mat_w		bigint;
nr_seq_item_w			bigint;
ie_status_conta_w		varchar(1);
nr_nota_w			ptu_nota_cobranca.nr_nota%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.qt_procedimento_imp, 
		a.vl_procedimento_imp, 
		a.qt_procedimento_imp - CASE WHEN a.vl_procedimento_imp=a.vl_glosa THEN 0  ELSE a.qt_procedimento END , 
		coalesce(a.vl_glosa,0), 
		CASE WHEN a.vl_procedimento_imp=a.vl_glosa THEN 0  ELSE a.qt_procedimento END , 
		coalesce(a.vl_liberado,0), 
		b.nr_sequencia, 
		'P' ie_tipo, 
		coalesce(a.ie_valor_base,'1'), 
		coalesce(a.vl_procedimento,0), 
		b.ie_status 
	from	pls_conta_proc	a, 
		pls_conta	b 
	where	a.nr_seq_conta	= b.nr_sequencia 
	and	b.nr_seq_fatura	= nr_seq_fatura_p 
	and	coalesce(a.vl_glosa,0) > 0 
	and	a.ie_status <> 'D' 
	
union all
 
	SELECT	a.nr_sequencia, 
		a.qt_material_imp, 
		a.vl_material_imp, 
		a.qt_material_imp - CASE WHEN a.vl_material_imp=a.vl_glosa THEN 0  ELSE a.qt_material END , 
		coalesce(a.vl_glosa,0), 
		CASE WHEN a.vl_material_imp=a.vl_glosa THEN 0  ELSE a.qt_material END , 
		coalesce(a.vl_liberado,0), 
		b.nr_sequencia, 
		'M' ie_tipo, 
		coalesce(a.ie_valor_base,'1'), 
		coalesce(a.vl_material,0), 
		b.ie_status 
	from	pls_conta_mat	a, 
		pls_conta	b 
	where	a.nr_seq_conta	= b.nr_sequencia 
	and	b.nr_seq_fatura	= nr_seq_fatura_p 
	and	coalesce(a.vl_glosa,0) > 0 
	and	a.ie_status <> 'D';


BEGIN 
nr_seq_lote_contest_p	:= null;
 
open C01;
loop 
fetch C01 into 
	nr_seq_item_w, 
	qt_apresentada_w, 
	vl_apresentado_w, 
	qt_glosa_w, 
	vl_glosa_w, 
	qt_liberada_w, 
	vl_liberado_w, 
	nr_seq_conta_w, 
	ie_tipo_w, 
	ie_valor_base_w, 
	vl_calulado_w, 
	ie_status_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (coalesce(nr_seq_lote_contest_w::text, '') = '') then 
		select	nextval('pls_lote_contestacao_seq') 
		into STRICT	nr_seq_lote_contest_w 
		;
		 
		insert	into	pls_lote_contestacao(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_referencia, 
				ie_envio_recebimento, 
				nr_seq_ptu_fatura, 
				ie_status, 
				cd_estabelecimento) 
		values (	nr_seq_lote_contest_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				'E', 
				nr_seq_fatura_p, 
				'A', 
				cd_estabelecimento_p);
		 
		nr_seq_lote_contest_p	:= nr_seq_lote_contest_w;
	end if;
	 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_contestacao_w 
	from	pls_contestacao a 
	where	a.nr_seq_conta	= nr_seq_conta_w 
	and	a.nr_seq_lote	= nr_seq_lote_contest_w;
	 
	select	max(x.nr_nota) 
	into STRICT	nr_nota_w 
	from	pls_conta y, 
		ptu_nota_cobranca x 
	where 	x.nr_sequencia = y.nr_seq_nota_cobranca 
	and	y.nr_sequencia = nr_seq_conta_w;
	 
	if (coalesce(nr_seq_contestacao_w::text, '') = '') then 
		select	nextval('pls_contestacao_seq') 
		into STRICT	nr_seq_contestacao_w 
		;
		 
		insert	into	pls_contestacao(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_lote, 
				nr_seq_conta, 
				vl_conta, 
				vl_atual, 
				vl_original, 
				ie_status, 
				nr_nota) 
		values (	nr_seq_contestacao_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_lote_contest_w, 
				nr_seq_conta_w, 
				0, 
				0, 
				0, 
				'C', 
				nr_nota_w);
	end if;
	 
	if (ie_tipo_w = 'P') then 
		select	nextval('pls_contestacao_proc_seq') 
		into STRICT	nr_seq_contest_proc_w 
		;
		 
		if (vl_glosa_w > vl_apresentado_w) then 
			vl_item_w := vl_calulado_w;
		else 
			vl_item_w := vl_apresentado_w;
		end if;
		 
		if (vl_glosa_w > vl_item_w) then 
			vl_item_w := vl_glosa_w;
		end if;
		 
		if (qt_apresentada_w = 0) and (vl_item_w > 0) then 
			qt_apresentada_w := 1;
		end if;
		 
		if (qt_glosa_w = 0) and (vl_glosa_w > 0) then 
			qt_glosa_w := 1;
		end if;
		 
		if (qt_liberada_w = 0) and (vl_liberado_w > 0) then 
			qt_liberada_w := 1;
		end if;
		 
		if (qt_glosa_w > qt_apresentada_w) then 
			qt_glosa_w := qt_apresentada_w;
		end if;
		 
		insert	into	pls_contestacao_proc(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_contestacao, 
				nr_seq_conta_proc, 
				qt_procedimento, 
				vl_procedimento, 
				qt_contestada, 
				vl_contestado, 
				qt_aceita, 
				vl_aceito) 
		values (		nr_seq_contest_proc_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_contestacao_w, 
				nr_seq_item_w, 
				qt_apresentada_w, 
				vl_item_w, 
				qt_glosa_w, 
				vl_glosa_w, 
				qt_liberada_w, 
				vl_liberado_w);
	else 
		select	nextval('pls_contestacao_mat_seq') 
		into STRICT	nr_seq_contest_mat_w 
		;
		 
		if (vl_glosa_w > vl_apresentado_w) then 
			vl_item_w := vl_calulado_w;
		else 
			vl_item_w := vl_apresentado_w;
		end if;
		 
		if (vl_glosa_w > vl_item_w) then 
			vl_item_w := vl_glosa_w;
		end if;
		 
		if (qt_apresentada_w = 0) and (vl_item_w > 0) then 
			qt_apresentada_w := 1;
		end if;
		 
		if (qt_glosa_w = 0) and (vl_glosa_w > 0) then 
			qt_glosa_w := 1;
		end if;
		 
		if (qt_liberada_w = 0) and (vl_liberado_w > 0) then 
			qt_liberada_w := 1;
		end if;
		 
		if (qt_glosa_w > qt_apresentada_w) then 
			qt_glosa_w := qt_apresentada_w;
		end if;
		 
		insert	into	pls_contestacao_mat(nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_contestacao, 
				nr_seq_conta_mat, 
				qt_material, 
				vl_material, 
				qt_contestada, 
				vl_contestado, 
				qt_aceita, 
				vl_aceito) 
		values (	nr_seq_contest_mat_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_contestacao_w, 
				nr_seq_item_w, 
				qt_apresentada_w, 
				vl_item_w, 
				qt_glosa_w, 
				vl_glosa_w, 
				qt_liberada_w, 
				vl_liberado_w);
	end if;
	 
	if (ie_status_conta_w = 'F') then /* Se a conta estiver fechada atualiza o status da coparticipação, senão o status será atualizado ao fechar a conta */
 
		CALL pls_atualiza_status_copartic(nr_seq_conta_w, 'FC', null, nm_usuario_p, cd_estabelecimento_p);
	end if;
	end;
end loop;
close C01;
 
-- Gerar as glosas 
CALL pls_gerar_glosas_lote_contest(	nr_seq_lote_contest_w, cd_estabelecimento_p, nm_usuario_p, 'N');
 
CALL pls_atualizar_valores_contest(	nr_seq_lote_contest_w, 'N');
				 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_contestacao ( nr_seq_fatura_p bigint, nr_seq_lote_contest_p INOUT bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

