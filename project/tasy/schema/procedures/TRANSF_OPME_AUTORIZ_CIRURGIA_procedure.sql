-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transf_opme_autoriz_cirurgia ( nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
dt_agenda_w		timestamp;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_atendimento_w	bigint;
cd_convenio_w		integer;
cd_estabelecimento_w	bigint;
ie_valor_conta_w	varchar(1);
cd_material_w		bigint;
qt_registro_w		bigint;
ds_observacao_w		varchar(4000);
qt_material_w		double precision;
nr_seq_agenda_w		bigint;
ie_entrou_w		varchar(1);
qt_mat_atual_w		double precision;
ie_estagio_autor_w	varchar(1);
cd_cgc_w		varchar(14);
nr_seq_marca_w		bigint;
nr_seq_mat_autor_w	bigint;

c01 CURSOR FOR
SELECT	a.cd_material,
	a.ds_observacao,
	a.qt_material,
	a.nr_sequencia,
	a.cd_cgc,
	a.nr_seq_marca
from	agenda_pac_opme a
where	a.nr_seq_agenda = nr_seq_agenda_p
and	coalesce(a.ie_origem_inf,'I') = 'I'
and	not exists (	SELECT	1
			from	material_autor_cirurgia x,
				autorizacao_cirurgia z
			where	x.nr_seq_autorizacao 	= z.nr_sequencia
			and	z.nr_seq_agenda		= nr_seq_agenda_p
			and	x.nr_seq_opme 		= a.nr_sequencia);
			
c02 CURSOR FOR
SELECT	a.cd_cgc
from	agenda_pac_opme_fornec a
where	a.nr_seq_opme	= nr_seq_agenda_w
and	not exists (SELECT 1 from material_autor_cir_cot x where x.nr_sequencia = nr_seq_mat_autor_w and x.cd_cgc = a.cd_cgc)
group by a.cd_cgc;



BEGIN

select	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_sequencia_w
from	autorizacao_cirurgia a
where	a.nr_seq_agenda 	= nr_seq_agenda_p
and	coalesce(a.ie_estagio_autor,'1') 	not in ('3','6') /* Autorizada ou Cancelada*/
and	not exists (	SELECT	1
			from	material_autor_cirurgia x
			where	x.nr_seq_autorizacao = a.nr_sequencia
			and	(x.nr_cot_compra IS NOT NULL AND x.nr_cot_compra::text <> ''));

if (nr_sequencia_w = 0) then

	select	nextval('autorizacao_cirurgia_seq')
	into STRICT	nr_sequencia_w
	;

	select	dt_agenda,
		cd_procedimento,
		ie_origem_proced,
		nr_atendimento,
		cd_convenio,
		obter_estab_agenda(cd_agenda)
	into STRICT	dt_agenda_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		nr_atendimento_w,
		cd_convenio_w,
		cd_estabelecimento_w
	from	agenda_paciente
	where	nr_sequencia = nr_seq_agenda_p;

	select	coalesce(max(ie_estagio_autor),'1')
	into STRICT	ie_estagio_autor_w
	from	parametro_faturamento
	where	cd_estabelecimento	= cd_estabelecimento_w;

	if (coalesce(cd_convenio_w::text, '') = '') then
		--r.aise_application_error(-20011,'Nao foi possivel transferir os OPMEs. Voce deve informar um convenio na agenda.');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(200409);
	end if;

	insert into	autorizacao_cirurgia(nr_sequencia,
			nm_usuario_autorizacao,
			nm_usuario_pedido,
			nr_seq_agenda,
			dt_previsao,
			cd_procedimento,
			ie_origem_proced,
			nr_atendimento,
			dt_pedido,
			nm_usuario,
			dt_atualizacao,
			cd_estabelecimento,
			ie_estagio_autor
			)
	values (nr_sequencia_w,
			nm_usuario_p,
			nm_usuario_p,
			nr_seq_agenda_p,
			dt_agenda_w,
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_atendimento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_estabelecimento_w,
			ie_estagio_autor_w);
end if;

select	cd_convenio,
	obter_estab_agenda(cd_agenda)
into STRICT	cd_convenio_w,
	cd_estabelecimento_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;

select 	max(coalesce(ie_vl_conta_autor,'N'))
into STRICT 	ie_valor_conta_w
from 	convenio_estabelecimento
where 	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_w;

ie_entrou_w	:= 'N';

open	c01;
loop
fetch	c01 into
	cd_material_w,
	ds_observacao_w,
	qt_material_w,
	nr_seq_agenda_w,
	cd_cgc_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	count(*)
	into STRICT	qt_registro_w
	from	material_autor_cirurgia x
	where	x.nr_seq_autorizacao	= nr_sequencia_w
	and	x.cd_material		= cd_material_w
	and	((exists (SELECT	1 from material_autor_cir_cot y
				where	y.nr_sequencia  = x.nr_sequencia
				and	coalesce(y.cd_cgc,'X') = coalesce(cd_cgc_w,'X'))) or
			((coalesce(x.nr_seq_opme::text, '') = '') or (x.nr_seq_opme		= nr_seq_agenda_w)));

	if (qt_registro_w	= 0) then

		ie_entrou_w	:= 'S';
		
		select	nextval('material_autor_cirurgia_seq')
		into STRICT	nr_seq_mat_autor_w
		;

		insert	into material_autor_cirurgia(nr_sequencia,
			nr_seq_autorizacao,
			dt_atualizacao,
			nm_usuario,
			cd_material,
			qt_material,
			ds_observacao,
			vl_material,
			ie_aprovacao,
			vl_unitario_material,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			qt_solicitada,
			nr_seq_fabricante,
			ie_origem_preco,
			pr_adicional,
			nr_seq_marca,
			ie_valor_conta,
			nr_seq_opme)
		values (nr_seq_mat_autor_w,
			nr_sequencia_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_w,
			0,
			ds_observacao_w,
			0,
			'N',
			0,
			clock_timestamp(),
			nm_usuario_p,
			qt_material_w,
			null,
			null,
			0,
			nr_seq_marca_w,
			ie_valor_conta_w,
			nr_seq_agenda_w);
			
		if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then

			insert 	into material_autor_cir_cot(nr_sequencia,
				cd_cgc,
				dt_atualizacao,
				nm_usuario,
				vl_cotado,
				cd_condicao_pagamento,
				vl_unitario_cotado,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_aprovacao,
				nr_seq_marca,
				nr_orcamento)
			values (nr_seq_mat_autor_w,
				cd_cgc_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				null,
				0,
				clock_timestamp(),
				nm_usuario_p,
				'N',
				nr_seq_marca_w,
				null);
		end if;
			
		open C02;
		loop
		fetch C02 into	
			cd_cgc_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			insert 	into material_autor_cir_cot(nr_sequencia,
				cd_cgc,
				dt_atualizacao,
				nm_usuario,
				vl_cotado,
				cd_condicao_pagamento,
				vl_unitario_cotado,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ie_aprovacao,
				nr_seq_marca,
				nr_orcamento)
			values (nr_seq_mat_autor_w,
				cd_cgc_w,
				clock_timestamp(),
				nm_usuario_p,
				0,
				null,
				0,
				clock_timestamp(),
				nm_usuario_p,
				'N',
				nr_seq_marca_w,
				null);
			
			end;
		end loop;
		close C02;

	else

		select	sum(qt_material)
		into STRICT	qt_mat_atual_w
		from	material_autor_cirurgia
		where	nr_seq_autorizacao = nr_sequencia_w
		and	cd_material = cd_material_w;

		if (coalesce(qt_material_w,0) <> coalesce(qt_mat_atual_w,0)) then

			ie_entrou_w	:= 'S';

			update	material_autor_cirurgia
			set	qt_material		= qt_material_w,
                nm_usuario = nm_usuario_p,
                dt_atualizacao = clock_timestamp()
			where	nr_seq_autorizacao	= nr_sequencia_w
			and	cd_material		= cd_material_w;

		end if;

	end if;
end	loop;
close	c01;

if (ie_entrou_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(252433);
end if;

CALL envia_email_transf_opme(nr_seq_agenda_p, nm_usuario_p, cd_estabelecimento_w);
CALL envia_ci_transf_opme(nr_seq_agenda_p, cd_estabelecimento_w, null, nm_usuario_p);

commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transf_opme_autoriz_cirurgia ( nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;
