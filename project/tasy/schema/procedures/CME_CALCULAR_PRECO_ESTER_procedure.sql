-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_calcular_preco_ester ( nr_sequencia_p bigint, nm_usuario_P text, ie_inicio_fim_p text) AS $body$
DECLARE


qt_ponto_w					double precision;
vl_ponto_w					double precision;
vl_ester_w					double precision;
cd_estabelecimento_w				integer;
cd_pessoa_fisica_w				varchar(10);
cd_cgc_w					varchar(14);
dt_referencia_w				timestamp;
ie_regra_preco_w				varchar(1);
cd_setor_atendimento_w			integer;

nr_seq_embalagem_w	bigint;
qt_dia_validade_w	integer;
qt_dia_validade_ww	integer;

/* Matheus OS 47496 em 08-01-2007 inclui order by no select */

c01 CURSOR FOR
	SELECT	coalesce(vl_ponto,0)
	from	cm_preco_ponto
	where	cd_estabelecimento		= cd_estabelecimento_w
	  and	dt_vigencia 			<= dt_referencia_w
	  and	coalesce(cd_pessoa_fisica,cd_pessoa_fisica_w) 	= cd_pessoa_fisica_w
	  and   coalesce(cd_setor_atendimento, cd_setor_atendimento_w) = cd_setor_atendimento_w
	  and	coalesce(cd_cgc,cd_cgc_w)		= cd_cgc_w
	  and	(((ie_regra_preco_w = 'Q') and (coalesce(qt_ponto::text, '') = '')) or
		(ie_regra_preco_w = 'F' AND qt_ponto = qt_ponto_w))
	order by coalesce(cd_setor_atendimento,0),
		 coalesce(cd_pessoa_fisica,0),
		 coalesce(cd_cgc,0);


BEGIN

select CASE WHEN coalesce(a.nr_seq_conjunto::text, '') = '' THEN (select coalesce(x.qt_ponto,0) from cm_item x where x.nr_sequencia = a.nr_seq_item)  ELSE (select coalesce(b.qt_ponto,0) from cm_conjunto b where b.nr_sequencia = a.nr_seq_conjunto) END  qt_ponto,
 coalesce(a.cd_setor_atendimento,0),
 coalesce(a.cd_pessoa_fisica,'X'),
 coalesce(a.cd_cgc,'X'),
 coalesce(a.dt_saida, coalesce(dt_baixa_cirurgia,clock_timestamp())),
 a.cd_estabelecimento,
 c.ie_regra_preco
into STRICT	qt_ponto_w,
	cd_setor_atendimento_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	dt_referencia_w,
	cd_estabelecimento_w,
	ie_regra_preco_w
from	cm_parametro c,
	cm_conjunto_cont a
where	a.nr_sequencia = nr_sequencia_p
and	coalesce(a.ie_situacao,'A')  = 'A'
and	a.cd_estabelecimento = c.cd_estabelecimento;

vl_ponto_w			:= 0;

OPEN 	c01;
LOOP
FETCH	c01 into	vl_ponto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	vl_ponto_w	:= vl_ponto_w;
	
END LOOP;
CLOSE c01;
if (ie_regra_preco_w = 'Q') then
	vl_ester_w	:= qt_ponto_w * vl_ponto_w;
else
	vl_ester_w	:= vl_ponto_w;
end if;

update	cm_conjunto_cont
set	nm_usuario		= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	qt_ponto		= qt_ponto_w,
	vl_esterilizacao	= vl_ester_w
where	nr_sequencia		= nr_sequencia_p;

if (ie_inicio_fim_p	= 'I') then
  select	max(nr_seq_embalagem)
	into STRICT	nr_seq_embalagem_w
	from	cm_conjunto_cont
	where	nr_sequencia = nr_sequencia_p;
	
	select	coalesce(max(qt_dia_validade), 0)
	into STRICT	qt_dia_validade_w
	from	cm_classif_embalagem
	where	nr_sequencia = nr_seq_embalagem_w;

  select	coalesce(max(qt_dia_validade), 0)
	into STRICT	qt_dia_validade_w
	from	cm_classif_embalagem
	where	nr_sequencia = nr_seq_embalagem_w;

  	if (qt_dia_validade_w > 0) then
      		select	coalesce(max(qt_dia_validade), 0)
          into STRICT	qt_dia_validade_ww
          from	cm_classif_embalagem
          where	nr_sequencia = nr_seq_embalagem_w
          and	coalesce(ie_indeterminado, 'N') = 'S';

          if (qt_dia_validade_ww = 0) then
            update	cm_conjunto_cont
            set	dt_validade = (clock_timestamp() + qt_dia_validade_w)
            where	nr_sequencia = nr_sequencia_p;
      		else
            update	cm_conjunto_cont
            set	dt_validade  = NULL,
              ie_indeterminado = 'S'
            where	nr_sequencia = nr_sequencia_p;
          end if;
    end if;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_calcular_preco_ester ( nr_sequencia_p bigint, nm_usuario_P text, ie_inicio_fim_p text) FROM PUBLIC;
