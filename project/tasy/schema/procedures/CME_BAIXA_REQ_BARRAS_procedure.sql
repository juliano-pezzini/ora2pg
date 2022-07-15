-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_baixa_req_barras ( nr_requisicao_p bigint, nr_seq_conj_ester_p bigint, nm_usuario_p text, cd_motivo_baixa_p bigint) AS $body$
DECLARE



nr_seq_conj_cont_w		bigint;
nr_seq_conj_ester_w		bigint;
nr_seq_conjunto_w			bigint;
nr_seq_controle_w			bigint;
nr_seq_item_req_w			bigint;
ie_status_conjunto_w		cm_conjunto_cont.ie_status_conjunto%type;
dt_validade_w			timestamp;
qt_conjunto_w			bigint;
qt_atendidos_w			bigint;
qt_existe_w			bigint;
ds_erro_w			varchar(255);
ie_atend_nao_ester_w		varchar(01);
cd_estabelecimento_w		smallint;
qt_conj_nao_atend_w		bigint;
qt_conjunto_igual_w		bigint;
ie_permite_atend_maior_w		varchar(1);
ie_permite_atend_dif_w		varchar(1);
nr_seq_generico_w			cm_conjunto.nr_seq_generico%type;

ie_conjunto_generico_w		varchar(1);
qt_existe_generico_w 		smallint := 0;
nr_seq_conj_ciclo_w 		cm_conjunto_cont.nr_seq_conjunto%type;
nr_seq_conj_ww				cm_conjunto.nr_sequencia%type;
nr_seq_item_ester_w 		cm_conjunto_cont.nr_seq_item%type;

nr_seq_classif_w			cm_item.nr_seq_classif%type;
nr_seq_classif_conj_req_w	cm_requisicao_item.nr_seq_classif_conj%type;
nr_seq_classif_req_w		cm_requisicao_item.nr_seq_classif%type;

c01 CURSOR FOR
SELECT	max(a.nr_sequencia) nr_sequencia,
		a.nr_seq_conjunto nr_seq_conjunto,
		max(a.qt_conjunto) qt_conjunto
from	cm_requisicao_item a,
		cm_conjunto b
where	a.nr_seq_requisicao = nr_requisicao_p
and 	a.nr_seq_conjunto 	= b.nr_sequencia
and		coalesce(a.cd_motivo_baixa::text, '') = ''
group by
		a.nr_seq_conjunto;
		
c02 CURSOR FOR
SELECT	max(a.nr_sequencia) nr_sequencia,
		a.nr_seq_conjunto nr_seq_conjunto,
		max(a.qt_conjunto) qt_conjunto,
		a.nr_seq_classif_conj nr_seq_classif_conj,
		a.nr_seq_classif nr_seq_classif
from	cm_requisicao_item a
where	a.nr_seq_requisicao = nr_requisicao_p
and ((a.nr_seq_classif_conj IS NOT NULL AND a.nr_seq_classif_conj::text <> '') or (a.nr_seq_classif IS NOT NULL AND a.nr_seq_classif::text <> ''))
and		coalesce(a.cd_motivo_baixa::text, '') = ''
group by
		a.nr_seq_conjunto,
		a.nr_seq_classif_conj,
		a.nr_seq_classif;

BEGIN

nr_seq_conj_cont_w := coalesce(nr_seq_conj_ester_p,0);

/*Obterm o valor do parâmetro*/

ie_conjunto_generico_w :=	coalesce(obter_valor_param_usuario(406, 230, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo), 'N');

IF (nr_seq_conj_cont_w = 0) THEN
	-- Erro ao ler o código de barras.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(152728);
END IF;

/* Pegar informações do conjunto */

SELECT	COUNT(*),
	MAX(a.dt_validade),
	MAX(a.ie_status_conjunto),
	coalesce(MAX(a.nr_seq_controle),0),
	MAX(nr_seq_conjunto),
	MAX(cd_estabelecimento),
	MAX(nr_seq_item)
INTO STRICT	qt_existe_w,
	dt_validade_w,
	ie_status_conjunto_w,
	nr_seq_controle_w,
	nr_seq_conj_ester_w,
	cd_estabelecimento_w,
	nr_seq_item_ester_w
FROM	cm_conjunto_cont a
WHERE	a.nr_sequencia = nr_seq_conj_cont_w
and	coalesce(a.ie_situacao,'A') = 'A'
AND	NOT EXISTS (	SELECT	1
			FROM	cm_requisicao_conj x
			WHERE	x.nr_seq_conj_real = a.nr_sequencia);

if (nr_seq_conj_ester_w IS NOT NULL AND nr_seq_conj_ester_w::text <> '') then
			
	select 	nr_seq_classif
	into STRICT	nr_seq_classif_w
	from 	cm_conjunto 
	where 	nr_sequencia = nr_seq_conj_ester_w;

elsif (nr_seq_item_ester_w IS NOT NULL AND nr_seq_item_ester_w::text <> '') then
	
	select 	nr_seq_classif
	into STRICT	nr_seq_classif_w
	from 	cm_item 
	where 	nr_sequencia = nr_seq_item_ester_w;

end if;



if (ie_conjunto_generico_w = 'S' and (nr_seq_conj_ester_w IS NOT NULL AND nr_seq_conj_ester_w::text <> '')) then --somente para conjunto

	/*Verifica se  o conjunto bipado é generico de alguns conjunto requisitado*/

	select	max(a.nr_seq_generico)
	into STRICT	nr_seq_generico_w
	from	cm_conjunto a
	where	a.nr_sequencia = nr_seq_conj_ester_w;
	
	select	count(1)
	into STRICT	qt_existe_generico_w
	from	cm_requisicao_item a,
			cm_requisicao b,
			cm_conjunto c
	where	nr_seq_requisicao 		= nr_requisicao_p
	and		b.nr_sequencia 			= a.nr_seq_requisicao
	and 	a.nr_seq_conjunto  		= c.nr_sequencia
	and 	c.nr_sequencia 			= nr_seq_generico_w
	and		a.dt_atualizacao_nrec	 < b.dt_liberacao;

end if;
			
			
/* Verificar se permite atender quantidade maior */

SELECT	coalesce(MAX(obter_valor_param_usuario(410, 16, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 'N')
INTO STRICT	ie_permite_atend_maior_w
;

/* Verificar se permite atender conjuntos diferentes */

SELECT	coalesce(MAX(obter_valor_param_usuario(410, 17, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 'N')
INTO STRICT	ie_permite_atend_dif_w
;

/* Verificar se permite atender conjuntos não esterilizados */

SELECT	coalesce(MAX(ie_atend_conj_nao_ester),'N')
INTO STRICT	ie_atend_nao_ester_w
FROM	cm_parametro
WHERE	cd_estabelecimento = cd_estabelecimento_w;

/* Consistências */

IF (ie_status_conjunto_w <> 3) AND (ie_atend_nao_ester_w = 'N') THEN
	-- Este conjunto não está com o status "Esterilizado".
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264814);

ELSIF (coalesce(TRUNC(dt_validade_w,'dd'),TRUNC(clock_timestamp(),'dd')) < TRUNC(clock_timestamp(), 'dd')) THEN
	-- Este conjunto não está dentro do prazo de validade.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264815);

ELSIF (qt_existe_w = 0) THEN
	-- Este conjunto inexistente ou já atendido.
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(264816);

END IF;

/* Verificar se ainda há alguma quantidade de conjunto não atendido do conjunto bipado */

if (ie_conjunto_generico_w = 'S' and (nr_seq_conj_ester_w IS NOT NULL AND nr_seq_conj_ester_w::text <> '')) then

	SELECT	COUNT(*)
	INTO STRICT	qt_conj_nao_atend_w
	FROM	cm_requisicao_item a,
			cm_conjunto b
	WHERE	a.nr_seq_requisicao = nr_requisicao_p
	and 	a.nr_seq_conjunto	= b.nr_sequencia
	AND		((a.nr_seq_conjunto = nr_seq_conj_ester_w) or (a.nr_seq_conjunto = nr_seq_generico_w))
	AND		coalesce(a.cd_motivo_baixa::text, '') = '';

else

	SELECT	COUNT(*)
	INTO STRICT	qt_conj_nao_atend_w
	FROM	cm_requisicao_item a
	WHERE	a.nr_seq_requisicao = nr_requisicao_p
	AND (a.nr_seq_conjunto = nr_seq_conj_ester_w or a.nr_seq_classif = nr_seq_classif_w or a.nr_seq_classif_conj = nr_seq_classif_w)
	AND		coalesce(a.cd_motivo_baixa::text, '') = '';

end if;
/* Verificar se há algum conjunto requisitado, igual ao conjunto bipado */

SELECT	COUNT(a.nr_sequencia)
INTO STRICT	qt_conjunto_igual_w
FROM	cm_requisicao_item a,
		cm_requisicao b
WHERE	nr_seq_requisicao = nr_requisicao_p
AND		b.nr_sequencia = a.nr_seq_requisicao
AND (nr_seq_conjunto = nr_seq_conj_ester_w or a.nr_seq_classif = nr_seq_classif_w or a.nr_seq_classif_conj = nr_seq_classif_w)
AND		a.dt_atualizacao_nrec < b.dt_liberacao;

/* Se houver quantidade de conjuntos requisitados para atender igual ao bipado, realiza o processo antigo (normal) */

IF (qt_conj_nao_atend_w <> 0)  THEN
	BEGIN

		for c01_row in c01 loop
			BEGIN

				nr_seq_item_req_w  :=	c01_row.nr_sequencia;
				nr_seq_conjunto_w  :=	c01_row.nr_seq_conjunto;
				qt_conjunto_w	   :=	c01_row.qt_conjunto;
			
				IF ((nr_seq_conjunto_w = nr_seq_conj_ester_w) or (nr_seq_generico_w = nr_seq_conjunto_w)) then
			
					SELECT	COUNT(*)
					INTO STRICT	qt_atendidos_w
					FROM	cm_requisicao_conj
					WHERE	nr_seq_item_req = nr_seq_item_req_w;

					IF (qt_conjunto_w < qt_atendidos_w + 1) THEN
						-- Não é permitido atender mais que a quantidade requisitada.
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(163515);
					END IF;

					ds_erro_w := cme_baixar_requisicao(	nr_requisicao_p, nr_seq_item_req_w, cd_motivo_baixa_p, TO_CHAR(nr_seq_conj_cont_w) || ',', nm_usuario_p, ds_erro_w);

					IF (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') THEN
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(193870,'DS_ERRO=' || ds_erro_w);
					END IF;

				END IF;

			END;
		END LOOP;	
	
		for c02_row in c02 loop
			
			BEGIN

			
				nr_seq_item_req_w	:= c02_row.nr_sequencia;
				nr_seq_conjunto_w	:= c02_row.nr_seq_conjunto;
				qt_conjunto_w		:= c02_row.qt_conjunto;
				nr_seq_classif_conj_req_w	:= c02_row.nr_seq_classif_conj;
				nr_seq_classif_req_w	:= c02_row.nr_seq_classif;
			
				IF (((nr_seq_classif_conj_req_w = nr_seq_classif_w) or (nr_seq_classif_req_w = nr_seq_classif_w)) or (nr_seq_generico_w = nr_seq_conjunto_w)) then
			
					SELECT	COUNT(*)
					INTO STRICT	qt_atendidos_w
					FROM	cm_requisicao_conj
					WHERE	nr_seq_item_req = nr_seq_item_req_w;

					IF (qt_conjunto_w < qt_atendidos_w + 1) THEN
						-- Não é permitido atender mais que a quantidade requisitada.
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(163515);
					END IF;

					ds_erro_w := cme_baixar_requisicao(	nr_requisicao_p, nr_seq_item_req_w, cd_motivo_baixa_p, TO_CHAR(nr_seq_conj_cont_w) || ',', nm_usuario_p, ds_erro_w);

					IF (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') THEN
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(193870,'DS_ERRO=' || ds_erro_w);
					END IF;

				END IF;

			END;
		END LOOP;

	
	END;
END IF;


/* Se não houver quantidade para atender do conjunto bipado */

IF (qt_conj_nao_atend_w = 0) THEN
	BEGIN

	if (qt_conjunto_igual_w 	= 0) and (ie_permite_atend_dif_w = 'N') and (qt_existe_generico_w 	= 0) then
		
		-- Não é permitido atender conjuntos diferentes do requisitado.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(264820);
	ELSIF (qt_conjunto_igual_w <> 0) AND (ie_permite_atend_maior_w = 'N') THEN
		-- Não é permitido atender mais que a quantidade requisitada.
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(163515);
	END IF;


	SELECT	nextval('cm_requisicao_item_seq')
	INTO STRICT	nr_seq_item_req_w
	;

	INSERT INTO CM_REQUISICAO_ITEM(
				nr_sequencia,
				nr_seq_requisicao,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_conjunto,
				qt_conjunto,
				cd_motivo_baixa,
				nm_usuario_atend,
				ie_devolucao,
				ie_emprestimo,
				ds_observacao,
				nr_seq_classif
				) VALUES (
						nr_seq_item_req_w,
						nr_requisicao_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_conj_ester_w,
						1,
						NULL,
						NULL,
						'N',
						'N',
						WHEB_MENSAGEM_PCK.get_texto(100332827,'DT='||clock_timestamp()||';HR='||TO_CHAR(clock_timestamp(),'hh24:mi:ss')||
							';NM_USUARIO='||upper(nm_usuario_p)),
						CASE WHEN coalesce(nr_seq_conj_ester_w::text, '') = '' THEN  nr_seq_classif_w  ELSE null END );

	COMMIT;


	ds_erro_w := cme_baixar_requisicao(	nr_requisicao_p, nr_seq_item_req_w, cd_motivo_baixa_p, TO_CHAR(nr_seq_conj_cont_w) || ',', nm_usuario_p, ds_erro_w);

	IF (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(193870,'DS_ERRO=' || ds_erro_w);
	END IF;

	END;
END IF;

IF (coalesce(ds_erro_w::text, '') = '') THEN
	COMMIT;
ELSE
	ROLLBACK;
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_baixa_req_barras ( nr_requisicao_p bigint, nr_seq_conj_ester_p bigint, nm_usuario_p text, cd_motivo_baixa_p bigint) FROM PUBLIC;

