-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mat_esp_prescr_cirurgia ( nr_prescricao_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_autor_cir_w	bigint;
cd_material_w		bigint;
qt_material_w		bigint;
cd_pessoa_fisica_w	autorizacao_cirurgia.cd_pessoa_fisica%type;
nr_seq_prescricao_w	prescr_material.nr_Sequencia%type;
qt_autor_w		bigint;
qt_solic_w		bigint;
ie_autor_generico_w	varchar(1);
cd_convenio_w		bigint;

c01 CURSOR FOR
SELECT	max(a.cd_material),
	sum(a.qt_material),
	max(a.nr_sequencia)
from	prescr_material a
where	a.nr_prescricao	= nr_prescricao_p
and	not exists (	select	1
			from	material_autor_cirurgia z,
				autorizacao_cirurgia y
			where (z.cd_material = a.cd_material or (ie_autor_generico_w = 'S' and z.cd_material = obter_material_generico(a.cd_material)))
			and	y.nr_sequencia	= z.nr_seq_autorizacao
			and	z.nr_prescricao = a.nr_prescricao
			and	z.nr_seq_prescricao = a.nr_sequencia
			and	y.nr_atendimento = nr_atendimento_p);


BEGIN


select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_p;


select	max(cd_convenio)
into STRICT	cd_convenio_w
from	atend_categoria_convenio
where	nr_atendimento	= nr_atendimento_p;

select	coalesce(max(ie_autor_generico),'N')
into STRICT	ie_autor_generico_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_w
and	cd_estabelecimento	= cd_estabelecimento_p;

open c01;
loop
fetch c01 into
	cd_material_w,
	qt_material_w,
	nr_seq_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	coalesce(sum(z.qt_material),0),
		coalesce(sum(z.qt_solicitada),0)
	into STRICT	qt_autor_w,
		qt_solic_w
	from	material_autor_cirurgia z,
		autorizacao_cirurgia w
	where	z.nr_seq_autorizacao 	= w.nr_sequencia
	and (z.cd_material = cd_material_w or (ie_autor_generico_w = 'S' and z.cd_material = obter_material_generico(cd_material_w)))
	and	w.nr_atendimento 		= nr_atendimento_p;

	if (qt_material_w > qt_autor_w) then

		select	max(nr_sequencia)
		into STRICT	nr_seq_autor_cir_w
		from 	autorizacao_cirurgia
		where	nr_atendimento	= nr_atendimento_p
		and	coalesce(dt_autorizacao::text, '') = ''
		and	coalesce(dt_liberacao::text, '') = '';

		if (coalesce(nr_seq_autor_cir_w::text, '') = '') then

			select	nextval('autorizacao_cirurgia_seq')
			into STRICT	nr_seq_autor_cir_w
			;

			select	max(cd_pessoa_fisica)
			into STRICT	cd_pessoa_fisica_w
			from	atendimento_paciente
			where	nr_atendimento	= nr_atendimento_p;

			insert into autorizacao_cirurgia(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				dt_pedido,
				nm_usuario_pedido,
				nr_atendimento,
				ie_estagio_autor,
				cd_estabelecimento,
				cd_pessoa_fisica,
				nr_prescricao)
			values (nr_seq_autor_cir_w,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nr_atendimento_p,
				1,
				cd_estabelecimento_p,
				cd_pessoa_fisica_w,
				nr_prescricao_p);

		end if;

		insert into material_autor_cirurgia(nr_sequencia,
			nr_seq_autorizacao,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			cd_material,
			qt_solicitada,
			qt_material,
			vl_material,
			ie_aprovacao,
			vl_unitario_material,
			ie_valor_conta,
			nr_prescricao,
			nr_seq_prescricao,
			ie_faturamento_direto)
		values (nextval('material_autor_cirurgia_seq'),
			nr_seq_autor_cir_w,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			cd_material_w,
			qt_material_w - qt_autor_w,
			0,
			0,
			'N',
			0,
			'N',
			nr_prescricao_p,
			nr_seq_prescricao_w,
			'N');
	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mat_esp_prescr_cirurgia ( nr_prescricao_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

