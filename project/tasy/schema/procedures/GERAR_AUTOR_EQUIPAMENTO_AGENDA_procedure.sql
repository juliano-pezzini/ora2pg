-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_autor_equipamento_agenda (nr_seq_agenda_p bigint, nr_atendimento_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_equipamento_w		bigint;
ie_tipo_autorizacao_w		varchar(15);
nr_sequencia_autor_w		bigint;
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_convenio_atend_w		bigint;
ie_tipo_atendimento_atend_w	smallint;
cd_tipo_acomodacao_atend_w	bigint;
cd_plano_convenio_w		varchar(10);
cd_categoria_w			varchar(10);
ds_erro_w			varchar(255):= '';
nr_seq_regra_w			bigint;
ie_regra_w			varchar(2) := '';
nr_seq_autorizacao_w		bigint;
nr_seq_proc_autor_w		bigint;
cd_estabelecimento_w		bigint;
count_w				integer := 0;
ds_equipamento_w		varchar(255);
cd_pessoa_fisica_w		varchar(10);
ds_texto_w			varchar(255);
ie_glosa_w			regra_ajuste_proc.ie_glosa%type;
nr_seq_regra_preco_w		regra_ajuste_proc.nr_sequencia%type;
c01 CURSOR FOR
SELECT	a.cd_equipamento,
	substr(b.ds_equipamento,1,255),
	b.cd_procedimento,
	b.ie_origem_proced
from 	equipamento b,
	agenda_pac_equip a
where	a.cd_equipamento	= b.cd_equipamento
and	a.nr_seq_agenda		= nr_seq_agenda_p;


BEGIN

select	ie_tipo_autorizacao
into STRICT	ie_tipo_autorizacao_w
from 	regra_gerar_autorizacao
where	nr_sequencia	= nr_seq_regra_p;

select	max(a.cd_convenio),
	max(a.ie_tipo_atendimento),
	max(a.cd_tipo_acomodacao),
	max(a.cd_plano),
	max(b.cd_estabelecimento),
	max(a.cd_categoria),
	max(a.cd_pessoa_fisica)
into STRICT	cd_convenio_atend_w,
	ie_tipo_atendimento_atend_w,
	cd_tipo_acomodacao_atend_w,
	cd_plano_convenio_w,
	cd_estabelecimento_w,
	cd_categoria_w,
	cd_pessoa_fisica_w
from	agenda b,
	agenda_paciente a
where	a.nr_sequencia			= nr_seq_agenda_p
and	a.cd_agenda			= b.cd_agenda;

select	max(a.nr_sequencia),
	max(a.nr_seq_autorizacao)
into STRICT	nr_sequencia_autor_w,
	nr_seq_autorizacao_w
from	autorizacao_convenio a,
	estagio_autorizacao b
where	a.nr_seq_estagio	= b.nr_sequencia
and	b.ie_interno		= '1' --Necessidade
and (a.nr_atendimento	= nr_atendimento_p or
	coalesce(a.nr_atendimento::text, '') = '')
and	a.nr_seq_agenda		= nr_seq_agenda_p
and	a.ie_tipo_autorizacao	= ie_tipo_autorizacao_w;

ds_texto_w := substr(wheb_mensagem_pck.get_texto(311546),1,255);--Procedimento gerado para o equipamento
if (nr_sequencia_autor_w IS NOT NULL AND nr_sequencia_autor_w::text <> '') then

	open c01;
	loop
	fetch c01 into
		cd_equipamento_w,
		ds_equipamento_w,
		cd_procedimento_w,
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then

			select	count(*)
			into STRICT	count_w
			from 	procedimento_autorizado
			where	nr_sequencia_autor	= nr_sequencia_autor_w
			and	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w;

			if (count_w = 0) then

				SELECT * FROM consiste_plano_convenio(nr_atendimento_p, cd_convenio_atend_w, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), 1, ie_tipo_atendimento_atend_w, cd_plano_convenio_w, null, ds_erro_w, null, null, ie_regra_w, nr_seq_agenda_p, nr_seq_regra_w, null, cd_categoria_w, cd_estabelecimento_w, null, null, cd_pessoa_fisica_w, ie_glosa_w, nr_Seq_regra_preco_w) INTO STRICT ds_erro_w, ie_regra_w, nr_seq_regra_w, ie_glosa_w, nr_Seq_regra_preco_w;

				if (ie_regra_w in ('3','6','7')) then

					select	nextval('procedimento_autorizado_seq')
					into STRICT	nr_seq_proc_autor_w
					;

					insert	into procedimento_autorizado(nr_atendimento,
							nr_seq_autorizacao,
							cd_procedimento,
							ie_origem_proced,
							qt_solicitada,
							qt_autorizada,
							nr_prescricao,
							nr_seq_prescricao,
							dt_atualizacao,
							nm_usuario,
							nr_sequencia_autor,
							nr_sequencia,
							nr_seq_proc_interno,
							ds_observacao)
						values (nr_atendimento_p,
							nr_seq_autorizacao_w,
							cd_procedimento_w,
							ie_origem_proced_w,
							1,
							0,
							null,
							null,
							clock_timestamp(),
							nm_usuario_p,
							nr_sequencia_autor_w,
							nr_seq_proc_autor_w,
							null,
							ds_texto_w ||' '|| ds_equipamento_w);

				end if;
			end if;
		end if;

	end loop;
	close c01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_autor_equipamento_agenda (nr_seq_agenda_p bigint, nr_atendimento_p bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;
