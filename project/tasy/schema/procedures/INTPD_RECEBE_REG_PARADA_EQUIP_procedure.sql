-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_reg_parada_equip ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ds_id_origin_w				intpd_eventos_sistema.ds_id_origin%type;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w			intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_conv_w			conversao_meio_externo.nr_seq_regra%type;
ie_sistema_externo_w			varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
man_equip_periodo_parado_w				man_equip_periodo_parado%rowtype;
ie_erro_w				varchar(1) := 'N';
nr_man_equip_per_par_del_w		man_equip_periodo_parado.nr_sequencia%type;
qt_registros_w				bigint;
ds_erro_w				varchar(2000);
ds_operacao_w				varchar(255);

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/STOP_RECORD' passing xml_p columns

	IE_ACTION			varchar(15)	path 'IE_ACTION',
	NR_EXTERNO_INT			varchar(40)	path 'NR_EXTERNO_INT',
	NR_SEQ_EQUIPAMENTO		bigint	path 'NR_SEQ_EQUIPAMENTO',
	NM_USUARIO			varchar(15)	path 'NM_USUARIO',
	NR_SEQ_REG_PARADA_OS		bigint	path 'NR_SEQ_REG_PARADA_OS',
	NR_SEQ_MOTIVO			bigint	path 'NR_SEQ_MOTIVO',
	DT_PERIODO_INICIAL		varchar(20)	path 'DT_PERIODO_INICIAL',
	DT_PERIODO_FINAL		varchar(20)	path 'DT_PERIODO_FINAL');

c01_w	c01%rowtype;

BEGIN

select	id_origin
into STRICT	ds_id_origin_w
from	xmltable('/STRUCTURE' passing xml_p
	columns id_origin	varchar2(10) path 'ID_ORIGIN');

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv,
	coalesce(ds_id_origin,ds_id_origin_w)
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_conv_w,
	ds_id_origin_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

ie_sistema_externo_w				:=	nr_seq_sistema_w;

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao			:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao		:=	nr_seq_regra_conv_w;

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_erro_w := 'N';

	if (c01_w.ie_action = 'E') then
		begin
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_man_equip_per_par_del_w
			from	man_equip_periodo_parado
			where	NR_EXTERNO_INT = c01_w.NR_EXTERNO_INT;

			delete from man_equip_periodo_parado where nr_sequencia = nr_man_equip_per_par_del_w;
		exception
		when others then
			ie_erro_w := 'S';
			intpd_gravar_log_recebimento(nr_sequencia_p, wheb_mensagem_pck.get_Texto(1027477), c01_w.nm_usuario);
		end;
	else
		reg_integracao_w.nm_tabela		:=	'MAN_EQUIP_PERIODO_PARADO';
		reg_integracao_w.nm_elemento		:=	'STOP_RECORD';
		reg_integracao_w.nr_seq_visao		:=	31099;

		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_EXTERNO_INT', c01_w.NR_EXTERNO_INT, 'S', man_equip_periodo_parado_w.NR_EXTERNO_INT) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.NR_EXTERNO_INT := _ora2pg_r.ds_valor_retorno_p;
		--Código externo do equipamento
		--intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_EQUIPAMENTO', c01_w.NR_SEQ_EQUIPAMENTO, 'S', man_equip_periodo_parado_w.NR_SEQ_EQUIPAMENTO);
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c01_w.NM_USUARIO, 'S', man_equip_periodo_parado_w.NM_USUARIO) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.NM_USUARIO := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_REG_PARADA_OS', c01_w.NR_SEQ_REG_PARADA_OS, 'S', man_equip_periodo_parado_w.NR_SEQ_REG_PARADA_OS) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.NR_SEQ_REG_PARADA_OS := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_MOTIVO', c01_w.NR_SEQ_MOTIVO, 'S', man_equip_periodo_parado_w.NR_SEQ_MOTIVO) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.NR_SEQ_MOTIVO := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_PERIODO_INICIAL', c01_w.DT_PERIODO_INICIAL, 'S', man_equip_periodo_parado_w.DT_PERIODO_INICIAL) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.DT_PERIODO_INICIAL := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_PERIODO_FINAL', c01_w.DT_PERIODO_FINAL, 'S', man_equip_periodo_parado_w.DT_PERIODO_FINAL) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; man_equip_periodo_parado_w.DT_PERIODO_FINAL := _ora2pg_r.ds_valor_retorno_p;

		man_equip_periodo_parado_w.dt_atualizacao := clock_timestamp();
		man_equip_periodo_parado_w.dt_atualizacao_nrec := clock_timestamp();
		man_equip_periodo_parado_w.nm_usuario_nrec := man_equip_periodo_parado_w.nm_usuario;

		begin
			if (reg_integracao_w.qt_reg_log = 0) then
				select coalesce(max(nr_sequencia),0)
				into STRICT man_equip_periodo_parado_w.nr_seq_equipamento
				from man_equipamento
				where man_equipamento.cd_imobilizado_ext = to_char(c01_w.nr_seq_equipamento);

				if (man_equip_periodo_parado_w.nr_seq_equipamento > 0) then
					select	coalesce(max(nr_sequencia),0)
					into STRICT	man_equip_periodo_parado_w.nr_sequencia
					from	man_equip_periodo_parado
					where	NR_EXTERNO_INT = man_equip_periodo_parado_w.NR_EXTERNO_INT
					and 	nr_seq_equipamento = man_equip_periodo_parado_w.nr_seq_equipamento;

					if (man_equip_periodo_parado_w.nr_sequencia > 0) then
						ds_operacao_w	:= 'UPDATE MAN_EQUIP_PERIODO_PARADO';
						update	man_equip_periodo_parado
						set	row = man_equip_periodo_parado_w
						where	nr_sequencia = man_equip_periodo_parado_w.nr_sequencia
						and nr_seq_equipamento = man_equip_periodo_parado_w.nr_seq_equipamento;
					else
						ds_operacao_w	:= 'INSERT MAN_EQUIP_PERIODO_PARADO';
						select	nextval('man_equip_periodo_parado_seq')
						into STRICT	man_equip_periodo_parado_w.nr_sequencia
						;

						insert into man_equip_periodo_parado values (man_equip_periodo_parado_w.*);

					end if;
				end if;
			end if;
		exception
		when others then
			ds_erro_w		:= substr(ds_operacao_w || ': ' || sqlerrm(SQLSTATE),1,2000);
			ie_erro_w := 'S';
			intpd_gravar_log_recebimento(nr_sequencia_p, ds_erro_w, c01_w.nm_usuario);
		end;
	end if;
	end;
end loop;
close C01;

if	((reg_integracao_w.qt_reg_log > 0) or (ie_erro_w = 'S')) then
	begin
	rollback;

	update 	intpd_fila_transmissao
	set	ie_status = 'E',
		ie_tipo_erro = 'F'
	where	nr_sequencia = nr_sequencia_p;

	for i in 0..reg_integracao_w.qt_reg_log-1 loop
		INTPD_GRAVAR_LOG_RECEBIMENTO(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;
else
	update	intpd_fila_transmissao
	set	ie_status = 'S',
		nr_seq_documento = coalesce(nr_man_equip_per_par_del_w, man_equip_periodo_parado_w.nr_sequencia),
		nr_doc_externo = c01_w.NR_EXTERNO_INT
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_reg_parada_equip ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;

