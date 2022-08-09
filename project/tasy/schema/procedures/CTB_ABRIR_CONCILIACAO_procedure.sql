-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_abrir_conciliacao ( nr_seq_concil_p bigint, nm_usuario_p text, cd_conta_contabil_p text, ie_operacao_p text) AS $body$
DECLARE


cd_estab_exclusivo_w		ctb_registro_concil.cd_estab_exclusivo%type;
cd_tipo_lote_contabil_w		ctb_registro_concil.cd_tipo_lote_contabil%type;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
ie_tem_lote_w			varchar(1);
nr_seq_mes_ref_w		ctb_registro_concil.nr_seq_mes_ref%type;
nr_seq_movimento_w		ctb_movimento.nr_sequencia%type;
qt_lote_concil_w		bigint;
qt_registro_w			bigint	:= 0;
dt_fim_mes_w			timestamp;

c_movimentos CURSOR FOR
SELECT 	a.nr_sequencia
from 	ctb_mes_ref c,
	lote_contabil b,
	ctb_movimento_v a
where	b.nr_lote_contabil	= a.nr_lote_contabil
and	c.nr_sequencia		= b.nr_seq_mes_ref
/*and	c.nr_sequencia		= nr_seq_mes_ref_w Retirado na OS 1435053
Alteração para trazer todos os movimentos não conciliados, independente do mês
*/
and	b.cd_estabelecimento	= coalesce(cd_estab_exclusivo_w, b.cd_estabelecimento)
and	b.cd_tipo_lote_contabil	= coalesce(cd_tipo_lote_contabil_w, b.cd_tipo_lote_contabil)
and	(b.dt_atualizacao_saldo IS NOT NULL AND b.dt_atualizacao_saldo::text <> '')
and (coalesce(a.nr_seq_reg_concil::text, '') = '' or coalesce(a.ie_status_concil,'NC') != 'C')
and	exists (	select	1
		from	ctb_registro_concil_conta y
		where	y.nr_seq_reg_concil	= nr_seq_concil_p
		and	y.cd_conta_contabil	= a.cd_conta_contabil)
and	a.dt_movimento <= dt_fim_mes_w;


BEGIN

select	a.nr_seq_mes_ref,
	a.dt_inicial,
	a.dt_final,
	a.cd_estab_exclusivo,
	a.cd_tipo_lote_contabil
into STRICT	nr_seq_mes_ref_w,
	dt_inicial_w,
	dt_final_w,
	cd_estab_exclusivo_w,
	cd_tipo_lote_contabil_w
from	ctb_registro_concil a
where	a.nr_sequencia	= nr_seq_concil_p;

select	fim_mes(dt_referencia)
into STRICT	dt_fim_mes_w
from 	ctb_mes_ref
where	nr_sequencia = nr_seq_mes_ref_w;

dt_inicial_w	:= trunc(dt_inicial_w);
dt_final_w	:= fim_dia(dt_final_w);

ie_tem_lote_w	:= 'N';
select	count(nr_lote_contabil)
into STRICT	qt_lote_concil_w
from	ctb_registro_concil_lote
where	nr_seq_reg_concil	= nr_seq_concil_p;

if (qt_lote_concil_w > 0) then
	ie_tem_lote_w	:= 'S';
end if;

if (ie_operacao_p = 'A') then

	open c_movimentos;
	loop
	fetch c_movimentos into
		nr_seq_movimento_w;
	EXIT WHEN NOT FOUND; /* apply on c_movimentos */
		begin

		update 	ctb_movimento a
		set 	a.ie_status_concil 	= 'NC',
			a.nr_seq_reg_concil 	= nr_seq_concil_p
		where 	a.nr_sequencia		= nr_seq_movimento_w;
		qt_registro_w	:= qt_registro_w + 1;
		if (qt_registro_w >= 500) then
			qt_registro_w	:= 0;
			commit;
		end if;
		end;
	end loop;
	close c_movimentos;

elsif (ie_operacao_p = 'D') then

	update 	ctb_movimento a
	set 	a.ie_status_concil 	= 'NC',
		a.nr_seq_reg_concil 	 = NULL
	where 	a.nr_seq_reg_concil	= nr_seq_concil_p;

end if;

update	ctb_registro_concil
set	dt_abertura		= CASE WHEN ie_operacao_p='A' THEN  clock_timestamp()  ELSE null END ,
	nm_usuario_abertura	= CASE WHEN ie_operacao_p='A' THEN  nm_usuario_p  ELSE null END
where	nr_sequencia		= nr_seq_concil_p;

CALL ctb_atualizar_concil(nr_seq_concil_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_abrir_conciliacao ( nr_seq_concil_p bigint, nm_usuario_p text, cd_conta_contabil_p text, ie_operacao_p text) FROM PUBLIC;
